import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/portfolio_data.dart';
import '../theme/app_colors.dart';
import 'glass_container.dart';

class ContactModal extends StatelessWidget {
  const ContactModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const ContactModal(),
    );
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
            const SizedBox(width: 10),
            Text('$label copied to clipboard!'),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const contact = PortfolioData.contact;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 16,
        right: 16,
      ),
      child: GlassContainer(
        blur: 24,
        opacity: 0.16,
        borderRadius: 28,
        borderColor: AppColors.glassBorderHighlight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Icon(
                    Icons.contact_mail_rounded,
                    color: AppColors.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Get In Touch',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Let\'s build something exceptional together',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Email
            _buildContactRow(
              context: context,
              icon: Icons.email_rounded,
              label: 'Email',
              value: contact.email,
              actionLabel: 'Copy Email',
              accentColor: AppColors.secondary,
              onTap: () => _copyToClipboard(context, contact.email, 'Email address'),
            ),
            const SizedBox(height: 10),

            // Phone
            _buildContactRow(
              context: context,
              icon: Icons.phone_rounded,
              label: 'Phone / WhatsApp',
              value: contact.phone,
              actionLabel: 'Copy Phone',
              accentColor: AppColors.success,
              onTap: () => _copyToClipboard(context, contact.phone, 'Phone number'),
            ),
            const SizedBox(height: 10),

            // Location
            _buildContactRow(
              context: context,
              icon: Icons.location_on_rounded,
              label: 'Location',
              value: contact.location,
              actionLabel: 'Copy Location',
              accentColor: AppColors.orbPink,
              onTap: () => _copyToClipboard(context, contact.location, 'Location'),
            ),
            const SizedBox(height: 10),

            // GitHub
            _buildContactRow(
              context: context,
              icon: Icons.code_rounded,
              label: 'GitHub',
              value: contact.githubUsername,
              actionLabel: 'Copy Link',
              accentColor: AppColors.primary,
              onTap: () => _copyToClipboard(context, contact.githubUrl, 'GitHub URL'),
            ),
            const SizedBox(height: 10),

            // LinkedIn
            _buildContactRow(
              context: context,
              icon: Icons.badge_rounded,
              label: 'LinkedIn',
              value: contact.linkedinName,
              actionLabel: 'Copy Link',
              accentColor: const Color(0xFF0077B5),
              onTap: () => _copyToClipboard(context, contact.linkedinUrl, 'LinkedIn URL'),
            ),
            const SizedBox(height: 14),

            // Invoicing & Razorpay Payments banner
            GlassContainer(
              blur: 8,
              opacity: 0.12,
              borderRadius: 14,
              borderColor: AppColors.success.withValues(alpha: 0.35),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/payment');
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.payments_rounded, color: AppColors.success, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Freelance Invoicing & Milestones',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Pay contract milestones securely via Razorpay',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.success),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Close button
            Center(
              child: TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textSecondary),
                label: const Text(
                  'Dismiss',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required String actionLabel,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GlassContainer(
      blur: 8,
      opacity: 0.08,
      borderRadius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
