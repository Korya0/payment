import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_getway/features/payment/data/repos/payment_repo.dart';
import 'package:payment_getway/features/payment/presentation/cubit/payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentCubit(this.paymentRepository) : super(PaymentInitial());

  Future<void> makePayment({
    required String amount,
    required String currency,
    required String
    customerId, // مستقبلاً سيأتي هذا من Auth Provider أو User Model
  }) async {
    emit(PaymentLoading());

    var initResult = await paymentRepository.initPaymentSheet(
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
        var displayResult = await paymentRepository.displayPaymentSheet();

        displayResult.fold(
          (failure) => emit(PaymentFailure(failure.errorMessage)),
          (success) => emit(PaymentSuccess()),
        );
      },
    );
  }
}
