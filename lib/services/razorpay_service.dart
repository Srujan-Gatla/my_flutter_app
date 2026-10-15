import 'package:flutter/foundation.dart';
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

  // Razorpay Test Key (default placeholder or customizable by user)
  // Replace with your Razorpay Dashboard Key ID (e.g. rzp_test_xxxxxxxxxx)
  String apiKey = 'rzp_test_TnoGKxU5GIcSQl';

  bool get isMobileNative =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  void initialize({
    required PaymentSuccessCallback onSuccess,
    required PaymentFailureCallback onFailure,
  }) {
    _onSuccess = onSuccess;
    _onFailure = onFailure;

    if (isMobileNative) {
      _razorpay?.clear();
      _razorpay = Razorpay();
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    final result = PaymentResult.success(
      paymentId: response.paymentId ?? 'pay_${DateTime.now().millisecondsSinceEpoch}',
      orderId: response.orderId,
      signature: response.signature,
    );
    _onSuccess?.call(result);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    final result = PaymentResult.failure(
      code: response.code,
      message: response.message ?? 'Payment failed or cancelled by user.',
    );
    _onFailure?.call(result);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    final result = PaymentResult.success(
      paymentId: 'wallet_${response.walletName}_${DateTime.now().millisecondsSinceEpoch}',
      orderId: response.walletName,
    );
    _onSuccess?.call(result);
  }

  /// Launch Razorpay Checkout
  Future<void> openCheckout({
    required double amount, // in INR
    required String milestoneTitle,
    required String clientName,
    required String clientEmail,
    required String clientPhone,
    bool forceSimulated = false,
  }) async {
    final amountInPaise = (amount * 100).toInt();

    // If running in simulated mode or on non-mobile platform where native SDK isn't present
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

    final options = {
      'key': apiKey,
      'amount': amountInPaise,
      'name': 'Srujan Gatla Engineering',
      'description': 'Milestone Payment: $milestoneTitle',
      'timeout': 300,
      'prefill': {
        'name': clientName.isNotEmpty ? clientName : 'Valued Client',
        'contact': clientPhone.isNotEmpty ? clientPhone : '9063966908',
        'email': clientEmail.isNotEmpty ? clientEmail : 'client@example.com',
      },
      'theme': {
        'color': '#8B5CF6',
        'backdrop_color': '#080C16',
      },
      'external': {
        'wallets': ['paytm']
      },
      'send_sms_hash': true,
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      _onFailure?.call(PaymentResult.failure(message: e.toString()));
    }
  }

  void dispose() {
    if (isMobileNative) {
      _razorpay?.clear();
      _razorpay = null;
    }
    _onSuccess = null;
    _onFailure = null;
  }
}
