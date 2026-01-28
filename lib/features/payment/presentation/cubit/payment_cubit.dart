import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_getway/features/payment/data/repos/payment_repo.dart';
import 'package:payment_getway/features/payment/presentation/cubit/payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentCubit(this.paymentRepository) : super(PaymentInitial());

  // دالة مخصصة لـ Stripe
  Future<void> makeStripePayment({
    required String amount,
    required String currency,
    required String customerId,
  }) async {
    emit(PaymentLoading());

    var initResult = await paymentRepository.initStripePayment(
      amount: amount,
      currency: currency,
      customerId: customerId,
    );

    await initResult.fold(
      (failure) {
        emit(PaymentFailure(failure.errorMessage));
      },
      (success) async {
        emit(PaymentReady());
        var displayResult = await paymentRepository.displayStripePaymentSheet();

        displayResult.fold(
          (failure) => emit(PaymentFailure(failure.errorMessage)),
          (success) => emit(PaymentSuccess()),
        );
      },
    );
  }

  // مستقبلاً يمكنك إضافة هذه الدالة
  // Future<void> makePaypalPayment() async { ... }
}
