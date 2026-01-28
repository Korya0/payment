import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

// Payment sheet is initialized and ready to be presented
class PaymentReady extends PaymentState {}

class PaymentSuccess extends PaymentState {}

class PaymentFailure extends PaymentState {
  final String errorMessage;
  const PaymentFailure(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
