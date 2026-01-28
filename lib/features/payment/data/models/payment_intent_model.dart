class PaymentIntentModel {
  final String clientSecret;
  final String? customerId;
  final String? ephemeralKey;

  PaymentIntentModel({
    required this.clientSecret,
    this.customerId,
    this.ephemeralKey,
  });

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) {
    return PaymentIntentModel(
      clientSecret: json['paymentIntent'] ?? json['client_secret'],
      customerId: json['customer'],
      ephemeralKey: json['ephemeralKey'],
    );
  }
}
