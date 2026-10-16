import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/invoice_model.dart';
import '../models/portfolio_data.dart';
import '../services/razorpay_service.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_container.dart';
import '../widgets/mesh_background.dart';

class PaymentInvoiceScreen extends StatefulWidget {
  final ProjectMilestone? initialMilestone;
  final bool initialSimulatedMode;

  const PaymentInvoiceScreen({
    super.key,
    this.initialMilestone,
    this.initialSimulatedMode = false,
  });

  @override
  State<PaymentInvoiceScreen> createState() => _PaymentInvoiceScreenState();
}

class _PaymentInvoiceScreenState extends State<PaymentInvoiceScreen> with WidgetsBindingObserver {
  late final List<ProjectMilestone> _milestones;
  late ProjectMilestone _selectedMilestone;
  late final RazorpayService _razorpayService;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController(text: 'Valued Client');
  final TextEditingController _emailController = TextEditingController(text: 'client@company.com');
  final TextEditingController _phoneController = TextEditingController(text: '9063966908');
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _baseUrlController = TextEditingController();

  bool _isProcessing = false;
  bool _forceSimulation = false;
  bool _showKeySettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _milestones = InvoiceMilestonesData.getDefaultMilestones();
    _selectedMilestone = widget.initialMilestone ?? _milestones[0];
    _amountController.text = _selectedMilestone.amount.toInt().toString();

    _razorpayService = RazorpayService();
    _apiKeyController.text = _razorpayService.apiKey;
    _baseUrlController.text = _razorpayService.baseUrl;

    _razorpayService.initialize(
      onSuccess: _onPaymentSuccess,
      onFailure: _onPaymentFailure,
    );

    // If on desktop, web, or explicitly requested, enable simulation mode
    if (!_razorpayService.isMobileNative || widget.initialSimulatedMode) {
      _forceSimulation = true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _razorpayService.dispose();
    _amountController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    _apiKeyController.dispose();
    _baseUrlController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isProcessing) {
      // Returned from Razorpay native activity.
      // Wait a brief moment for native callbacks; if none arrive, reset processing state.
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted && _isProcessing) {
          setState(() {
            _isProcessing = false;
          });
        }
      });
    }
  }

  void _onMilestoneSelected(ProjectMilestone ms) {
    setState(() {
      _selectedMilestone = ms;
      _amountController.text = ms.amount.toInt().toString();
    });
  }

  void _onPaymentSuccess(PaymentResult result) {
    setState(() {
      _isProcessing = false;
      _selectedMilestone.status = PaymentStatus.paid;
      _selectedMilestone.paymentId = result.paymentId;
      _selectedMilestone.paidAt = result.timestamp;
    });

    _showReceiptDialog(result);
  }

  void _onPaymentFailure(PaymentResult result) {
    if (!mounted) return;
    setState(() {
      _isProcessing = false;
    });

    final isCancellation = result.errorCode == 2 ||
        (result.errorMessage != null &&
            (result.errorMessage!.toLowerCase().contains('cancel') ||
                result.errorMessage!.toLowerCase().contains('user')));

    if (isCancellation) {
      _showCancellationDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.tertiary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  result.errorMessage ?? 'Payment was cancelled or unsuccessful.',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF2D1525),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showCancellationDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: GlassContainer(
              blur: 24,
              opacity: 0.18,
              borderRadius: 24,
              borderColor: AppColors.tertiary.withValues(alpha: 0.4),
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.tertiary.withValues(alpha: 0.15),
                      border: Border.all(
                        color: AppColors.tertiary.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: AppColors.tertiary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Payment Cancelled',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You exited the Razorpay gateway before completing the transaction. No amount was debited from your account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _startCheckout() async {
    final enteredAmount = double.tryParse(_amountController.text) ?? _selectedMilestone.amount;

    if (enteredAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid payment amount.')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Update API Key if modified
    if (_apiKeyController.text.trim().isNotEmpty) {
      _razorpayService.apiKey = _apiKeyController.text.trim();
    }
    if (_baseUrlController.text.trim().isNotEmpty) {
      _razorpayService.baseUrl = _baseUrlController.text.trim();
    }

    await _razorpayService.openCheckout(
      amount: enteredAmount,
      milestoneTitle: _selectedMilestone.title,
      clientName: _nameController.text.trim(),
      clientEmail: _emailController.text.trim(),
      clientPhone: _phoneController.text.trim(),
      forceSimulated: _forceSimulation,
    );
  }

  void _showReceiptDialog(PaymentResult result) {
    final amountPaid = double.tryParse(_amountController.text) ?? _selectedMilestone.amount;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: GlassContainer(
              blur: 24,
              opacity: 0.18,
              borderRadius: 24,
              borderColor: AppColors.success.withValues(alpha: 0.4),
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Success Icon with Glow
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withValues(alpha: 0.15),
                      border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withValues(alpha: 0.4),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.success,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    'Payment Successful!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Razorpay Verified Digital Receipt',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Receipt details glass box
                  GlassContainer(
                    blur: 10,
                    opacity: 0.08,
                    borderRadius: 16,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildReceiptRow('Amount Paid', '₹${amountPaid.toStringAsFixed(0)}', isHighlight: true),
                        const Divider(color: Colors.white12, height: 16),
                        _buildReceiptRow('Payment ID', result.paymentId ?? 'pay_verified'),
                        const SizedBox(height: 8),
                        _buildReceiptRow('Milestone', _selectedMilestone.title),
                        const SizedBox(height: 8),
                        _buildReceiptRow('Beneficiary', PortfolioData.name),
                        const SizedBox(height: 8),
                        _buildReceiptRow('Date & Time', '${DateTime.now().toLocal()}'.substring(0, 16)),
                        const SizedBox(height: 8),
                        _buildReceiptRow('Gateway', 'Razorpay (UPI / Cards / NetBanking)'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: result.paymentId ?? ''));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Transaction Reference copied!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.glassBorderHighlight),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                          ),
                          icon: const Icon(Icons.copy_rounded, size: 14, color: AppColors.secondary),
                          label: const Text('Copy ID', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close receipt
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                          ),
                          child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: isHighlight ? 15 : 12,
              fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
              color: isHighlight ? AppColors.secondary : AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: MeshBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildTopBar(),

              // Scrollable Checkout Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Overview Banner
                      _buildSecurityBanner(),
                      const SizedBox(height: 16),

                      // Milestone Selector Section
                      _buildSectionLabel('Select Project Milestone', Icons.view_timeline_rounded),
                      const SizedBox(height: 10),
                      ..._milestones.map((ms) => _buildMilestoneTile(ms)),
                      const SizedBox(height: 18),

                      // Selected Milestone Deliverables Card
                      _buildDeliverablesCard(),
                      const SizedBox(height: 18),

                      // Payment Amount Card
                      _buildAmountSection(),
                      const SizedBox(height: 18),

                      // Client Billing Details Form
                      _buildClientDetailsForm(),
                      const SizedBox(height: 18),

                      // Developer & Gateway Config
                      _buildGatewaySettingsCard(),
                      const SizedBox(height: 24),

                      // Checkout Action Button
                      _buildCheckoutButton(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          GlassContainer(
            blur: 12,
            opacity: 0.1,
            borderRadius: 14,
            padding: const EdgeInsets.all(10),
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Milestone Payments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Freelance Invoicing & Retainer Deposits',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.35),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt_rounded, size: 14, color: AppColors.secondary),
                SizedBox(width: 4),
                Text(
                  'Razorpay',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityBanner() {
    return GlassContainer(
      blur: 14,
      opacity: 0.08,
      borderRadius: 18,
      padding: const EdgeInsets.all(14),
      borderColor: AppColors.primary.withValues(alpha: 0.3),
      child: const Row(
        children: [
          Icon(Icons.verified_user_rounded, color: AppColors.secondary, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '100% Encrypted & Bank-Grade Security',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Powered by Razorpay: GPay, PhonePe, Paytm, Cards, NetBanking, and Wallets.',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.secondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneTile(ProjectMilestone ms) {
    final isSelected = _selectedMilestone.id == ms.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GlassContainer(
        blur: 10,
        opacity: isSelected ? 0.14 : 0.06,
        borderRadius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        borderColor: isSelected
            ? AppColors.secondary.withValues(alpha: 0.6)
            : AppColors.glassBorder,
        shadows: isSelected
            ? [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
        onTap: () => _onMilestoneSelected(ms),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (isSelected ? AppColors.secondary : AppColors.primary)
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                ms.icon,
                color: isSelected ? AppColors.secondary : AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ms.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ms.project,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.secondary.withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? AppColors.secondary.withValues(alpha: 0.4)
                      : Colors.white12,
                ),
              ),
              child: Text(
                '₹${ms.amount.toInt()}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? AppColors.secondary : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliverablesCard() {
    return GlassContainer(
      blur: 12,
      opacity: 0.08,
      borderRadius: 18,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.checklist_rounded, size: 16, color: AppColors.secondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Included Deliverables for ${_selectedMilestone.id}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _selectedMilestone.description,
            style: const TextStyle(
              fontSize: 12,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          ..._selectedMilestone.deliverables.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return GlassContainer(
      blur: 14,
      opacity: 0.1,
      borderRadius: 20,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Amount (INR)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),

          // Numeric Amount Input
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
                ),
                child: const Text(
                  '₹',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    hintStyle: const TextStyle(color: Colors.white30),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.06),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.secondary),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Quick Amount Presets
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [10000, 15000, 20000, 25000, 50000].map((preset) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _amountController.text = preset.toString();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    '+ ₹$preset',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildClientDetailsForm() {
    return GlassContainer(
      blur: 14,
      opacity: 0.08,
      borderRadius: 20,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Client & Invoice Details',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          _buildInputField(
            controller: _nameController,
            label: 'Client Name / Company',
            icon: Icons.business_rounded,
          ),
          const SizedBox(height: 10),

          _buildInputField(
            controller: _emailController,
            label: 'Client Email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 10),

          _buildInputField(
            controller: _phoneController,
            label: 'Phone Number (for UPI & SMS Receipt)',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 10),

          _buildInputField(
            controller: _notesController,
            label: 'Project Reference / Invoice Notes (Optional)',
            icon: Icons.edit_note_rounded,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.secondary),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _buildGatewaySettingsCard() {
    return GlassContainer(
      blur: 10,
      opacity: 0.06,
      borderRadius: 16,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _showKeySettings = !_showKeySettings;
              });
            },
            child: Row(
              children: [
                const Icon(Icons.settings_suggest_rounded, size: 16, color: AppColors.secondary),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Gateway Configuration & Test Mode',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Icon(
                  _showKeySettings ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                  color: AppColors.textSecondary,
                  size: 18,
                ),
              ],
            ),
          ),
          if (_showKeySettings) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _apiKeyController,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                labelText: 'Razorpay Key ID',
                labelStyle: const TextStyle(color: Colors.white54, fontSize: 11),
                helperText: 'Default test key loaded. Replace with your Razorpay live/test key anytime.',
                helperStyle: const TextStyle(color: Colors.white38, fontSize: 10),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _baseUrlController,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                labelText: 'Backend Server URL (Optional)',
                labelStyle: const TextStyle(color: Colors.white54, fontSize: 11),
                helperText: 'e.g. http://10.0.2.2:5000 (emulator) or http://192.168.80.124:5000 (device). Direct checkout is used if offline.',
                helperStyle: const TextStyle(color: Colors.white38, fontSize: 10),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Simulate Checkout (Sandbox Test Mode)',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              subtitle: const Text(
                'Simulates instant transaction response without opening native SDK (ideal for desktop/browser testing)',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
              value: _forceSimulation,
              activeThumbColor: AppColors.secondary,
              onChanged: (val) {
                setState(() {
                  _forceSimulation = val;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    final enteredAmount = double.tryParse(_amountController.text) ?? _selectedMilestone.amount;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.orbBlue,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _startCheckout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: _isProcessing
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Opening Razorpay Gateway...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_rounded, size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      'Pay ₹${enteredAmount.toStringAsFixed(0)} via Razorpay',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
