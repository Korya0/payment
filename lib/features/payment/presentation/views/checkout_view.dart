import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_getway/core/utils/stripe_keys.dart';
import 'package:payment_getway/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:payment_getway/features/payment/presentation/cubit/payment_state.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe Checkout'), centerTitle: true),
      body: Center(
        child: BlocConsumer<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment Successful!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is PaymentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.errorMessage}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is PaymentLoading) {
              return const CircularProgressIndicator();
            }

            return ElevatedButton(
              onPressed: () {
                // استخدام الـ Customer ID من ملف الثوابت
                context.read<PaymentCubit>().makePayment(
                  amount: '1500',
                  currency: 'USD',
                  customerId: StripeKeys.testCustomerId,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text('Pay Now with Stripe'),
            );
          },
        ),
      ),
    );
  }
}
