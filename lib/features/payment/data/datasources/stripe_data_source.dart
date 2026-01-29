import 'package:dio/dio.dart';
import 'package:payment_getway/core/utils/stripe_keys.dart';
import 'package:payment_getway/features/payment/data/models/stripe_payment_model.dart';

abstract class StripeDataSource {
  Future<StripePaymentModel> getPaymentSecrets({
    required String amount,
    required String currency,
    required String customerId,
  });
}

class StripeDataSourceImpl implements StripeDataSource {
  final Dio dio = Dio();

  @override
  Future<StripePaymentModel> getPaymentSecrets({
    required String amount,
    required String currency,
    required String customerId,
  }) async {
    try {
      // 1. Ephemeral Key
      final ephemeralKeyResponse = await dio.post(
        'https://api.stripe.com/v1/ephemeral_keys',
        data: {'customer': customerId},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer ${StripeKeys.secretKey}',
            'Stripe-Version': '2023-10-16',
          },
        ),
      );

      // 2. Payment Intent
      final paymentIntentResponse = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: {'amount': amount, 'currency': currency, 'customer': customerId},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {'Authorization': 'Bearer ${StripeKeys.secretKey}'},
        ),
      );

      return StripePaymentModel(
        clientSecret: paymentIntentResponse.data['client_secret'],
        customerId: customerId,
        ephemeralKey: ephemeralKeyResponse.data['secret'],
      );
    } catch (e) {
      throw Exception('Stripe Error: ${e.toString()}');
    }
  }
}
