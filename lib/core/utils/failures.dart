abstract class Failure {
  final String errorMessage;

  const Failure(this.errorMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errorMessage);
}

class StripeFailure extends Failure {
  StripeFailure(super.errorMessage);
}
