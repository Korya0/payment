import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_getway/core/utils/failures.dart';
import 'package:payment_getway/core/utils/stripe_keys.dart';
import 'package:payment_getway/features/payment/data/datasources/stripe_remote_data_source.dart';
import 'package:payment_getway/features/payment/data/models/payment_intent_model.dart';

abstract class PaymentRepository {
  Future<Either<Failure, void>> initPaymentSheet({
    required String amount,
    required String currency,
    required String customerId,
  });
  Future<Either<Failure, void>> displayPaymentSheet();
}

class PaymentRepositoryImpl implements PaymentRepository {
  final StripeRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> initPaymentSheet({
    required String amount,
    required String currency,
    required String customerId,
  }) async {
    try {
      final PaymentIntentModel secrets = await remoteDataSource
          .getPaymentSecrets(
            amount: amount,
            currency: currency,
            customerId: customerId,
          );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: secrets.clientSecret,
          customerEphemeralKeySecret: secrets.ephemeralKey,
          customerId: secrets.customerId,
          allowsDelayedPaymentMethods: true,

          /// Apple Pay Support
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: StripeKeys.applePayCountryCode,
          ),

          /// Google Pay Support
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: StripeKeys.googlePayCountryCode,
            testEnv: StripeKeys.isGooglePayTestEnv,
          ),
          style: ThemeMode.system,
        ),
      );
      return const Right(null);
    } catch (e) {
      if (e is StripeException) {
        return Left(StripeFailure(e.error.localizedMessage ?? 'Stripe Error'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return const Right(null);
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return Left(StripeFailure('Payment Canceled'));
      }
      return Left(StripeFailure(e.error.localizedMessage ?? 'Stripe Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
