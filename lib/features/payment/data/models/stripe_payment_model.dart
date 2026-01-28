class StripePaymentModel {
  final String clientSecret;
  final String? customerId;
  final String? ephemeralKey;

  StripePaymentModel({
    required this.clientSecret,
    this.customerId,
    this.ephemeralKey,
  });

  factory StripePaymentModel.fromJson(Map<String, dynamic> json) {
    return StripePaymentModel(
      clientSecret: json['paymentIntent'] ?? json['client_secret'],
      customerId: json['customer'],
      ephemeralKey: json['ephemeralKey'],
    );
  }
}
