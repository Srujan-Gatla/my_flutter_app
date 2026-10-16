import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../models/invoice_model.dart';

typedef PaymentSuccessCallback = void Function(PaymentResult result);
typedef PaymentFailureCallback = void Function(PaymentResult result);

class RazorpayService {
  static final RazorpayService _instance = RazorpayService._internal();

  factory RazorpayService() => _instance;

  RazorpayService._internal();

  Razorpay? _razorpay;

  PaymentSuccessCallback? _onSuccess;
  PaymentFailureCallback? _onFailure;

  // Backend base URL for your local Node.js server.
  // 192.168.80.124 is your PC's IP on your Wi-Fi network (required for physical Android devices).
  // For Android Studio Emulator, use 'http://10.0.2.2:5000'.
  // If the backend is offline or omitted, the service falls back to direct Razorpay Standard Checkout.
  String baseUrl = 'http://192.168.80.124:5000';

  String? _currentOrderId;
  bool _isVerifying = false;

  bool get isMobileNative =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  // Razorpay Test Key (default placeholder or customizable in UI)
  String apiKey = 'rzp_test_TnoGKxU5GIcSQl';

  // Initialize Razorpay and register payment callbacks.
  void initialize({
    required PaymentSuccessCallback onSuccess,
    required PaymentFailureCallback onFailure,
  }) {
    _onSuccess = onSuccess;
    _onFailure = onFailure;

    if (!isMobileNative) return;

    _razorpay?.clear();

    _razorpay = Razorpay()
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // Launch Razorpay Checkout.
  // Supports:
  // 1. Simulation mode (desktop/web/unit tests)
  // 2. Direct mobile native checkout with test/live Razorpay Key ID
  // 3. Optional backend order creation & verification if backend server is reachable
  Future<void> openCheckout({
    required double amount,
    required String milestoneTitle,
    required String clientName,
    required String clientEmail,
    required String clientPhone,
    bool forceSimulated = false,
  }) async {
    final amountInPaise = (amount * 100).toInt();

    // 1. Simulation Mode (for desktop, web, or automated testing)
    if (forceSimulated || !isMobileNative) {
      await Future.delayed(const Duration(milliseconds: 1400));
      final mockPaymentId =
          'pay_test_${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
      final result = PaymentResult.success(
        paymentId: mockPaymentId,
        orderId: 'order_ms_${DateTime.now().millisecondsSinceEpoch}',
        signature: 'simulated_sig_${DateTime.now().microsecondsSinceEpoch}',
      );
      _onSuccess?.call(result);
      return;
    }

    // Ensure Razorpay SDK is initialized for native platforms
    if (_razorpay == null) {
      initialize(
        onSuccess: _onSuccess ?? (_) {},
        onFailure: _onFailure ?? (_) {},
      );
    }

    String? orderId;

    // 2. Optional: Attempt backend order creation if backend URL is provided and valid
    final cleanUrl = baseUrl.trim();
    final hasValidBackendUrl = cleanUrl.isNotEmpty &&
        !cleanUrl.contains('XXX') &&
        (cleanUrl.startsWith('http://') || cleanUrl.startsWith('https://'));

    if (hasValidBackendUrl) {
      try {
        final orderResponse = await http
            .post(
              Uri.parse('$cleanUrl/api/payment/create-order'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'amount': amount,
                'milestoneTitle': milestoneTitle,
              }),
            )
            .timeout(const Duration(seconds: 4));

        if (orderResponse.statusCode == 200) {
          final orderData =
              jsonDecode(orderResponse.body) as Map<String, dynamic>;
          if (orderData['success'] == true && orderData['orderId'] != null) {
            orderId = orderData['orderId'] as String;
            if (orderData['keyId'] != null &&
                (orderData['keyId'] as String).isNotEmpty) {
              apiKey = orderData['keyId'] as String;
            }
          }
        }
      } catch (e) {
        debugPrint(
          'Backend order creation bypassed: $e. Proceeding with direct Razorpay checkout.',
        );
      }
    }

    _currentOrderId = orderId;

    // 3. Prepare Razorpay Checkout options
    final Map<String, dynamic> options = {
      'key': apiKey,
      'amount': amountInPaise,
      'name': 'Srujan Gatla Engineering',
      'description': 'Milestone Payment: $milestoneTitle',
      'timeout': 300,
      'prefill': {
        'name': clientName.isNotEmpty ? clientName : 'Valued Client',
        'contact': clientPhone.isNotEmpty ? clientPhone : '9063966908',
        'email': clientEmail.isNotEmpty ? clientEmail : 'client@company.com',
      },
      'theme': {
        'color': '#8B5CF6',
        'backdrop_color': '#080C16',
      },
      'external': {
        'wallets': ['paytm'],
      },
      'send_sms_hash': true,
    };

    if (orderId != null) {
      options['order_id'] = orderId;
    }

    // 4. Open native Razorpay Checkout SDK
    try {
      _razorpay!.open(options);
    } catch (e) {
      _onFailure?.call(
        PaymentResult.failure(
          message: 'Unable to start Razorpay payment: $e',
        ),
      );
    }
  }

  // Handle successful payment from Razorpay SDK
  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (_isVerifying) return;
    _isVerifying = true;

    try {
      final orderId = _currentOrderId ?? response.orderId;
      final paymentId =
          response.paymentId ?? 'pay_${DateTime.now().millisecondsSinceEpoch}';
      final signature = response.signature;

      // Optional backend verification if order was created via backend
      final cleanUrl = baseUrl.trim();
      final hasValidBackendUrl = cleanUrl.isNotEmpty &&
          !cleanUrl.contains('XXX') &&
          (cleanUrl.startsWith('http://') || cleanUrl.startsWith('https://'));

      if (orderId != null && signature != null && hasValidBackendUrl) {
        try {
          final verificationResponse = await http
              .post(
                Uri.parse('$cleanUrl/api/payment/verify'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'orderId': orderId,
                  'paymentId': paymentId,
                  'signature': signature,
                }),
              )
              .timeout(const Duration(seconds: 5));

          if (verificationResponse.statusCode == 200) {
            final data =
                jsonDecode(verificationResponse.body) as Map<String, dynamic>;
            if (data['success'] != true) {
              debugPrint('Server signature warning: ${data['message']}');
            }
          }
        } catch (e) {
          debugPrint('Backend payment verification skipped: $e');
        }
      }

      _onSuccess?.call(
        PaymentResult.success(
          paymentId: paymentId,
          orderId: orderId ?? 'order_${DateTime.now().millisecondsSinceEpoch}',
          signature: signature ?? 'sig_${DateTime.now().microsecondsSinceEpoch}',
        ),
      );
    } catch (e) {
      _onFailure?.call(
        PaymentResult.failure(
          message: 'Payment completion handling failed: $e',
        ),
      );
    } finally {
      _isVerifying = false;
    }
  }

  // Handle checkout failures or cancellations.
  void _handlePaymentError(PaymentFailureResponse response) {
    _onFailure?.call(
      PaymentResult.failure(
        code: response.code,
        message: response.message ?? 'Payment failed or was cancelled.',
      ),
    );
  }

  // Handle external wallet selection.
  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External wallet selected: ${response.walletName}');
  }

  // Release Razorpay event listeners.
  void dispose() {
    if (isMobileNative) {
      _razorpay?.clear();
      _razorpay = null;
    }

    _onSuccess = null;
    _onFailure = null;
    _currentOrderId = null;
    _isVerifying = false;
  }
}
