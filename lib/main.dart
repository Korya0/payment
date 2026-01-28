import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_getway/core/utils/bloc_observer.dart';
import 'package:payment_getway/core/utils/stripe_keys.dart';
import 'package:payment_getway/features/payment/data/datasources/stripe_data_source.dart';
import 'package:payment_getway/features/payment/data/repos/payment_repo.dart';
import 'package:payment_getway/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:payment_getway/features/payment/presentation/views/checkout_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🌍 Global Stripe Configuration
  Stripe.publishableKey = StripeKeys.publishableKey;
  Stripe.merchantIdentifier = StripeKeys.merchantIdentifier;

  await Stripe.instance.applySettings();

  Bloc.observer = AppBlocObserver();
  runApp(const PaymentApp());
}

class PaymentApp extends StatelessWidget {
  const PaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentCubit(
        PaymentRepositoryImpl(
          StripeDataSourceImpl(),
        ), // استخدام الاسم الجديد الموحد
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        home: const CheckoutView(),
      ),
    );
  }
}
