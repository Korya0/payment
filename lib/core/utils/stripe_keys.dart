class StripeKeys {
  // 1. Stripe API Keys (Get from Dashboard)
  // تذكر: لا ترفع الـ Secret Key أبداً على GitHub!
  static const String publishableKey = "ضع_هنا_الـ_Publishable_Key";
  static const String secretKey = "ضع_هنا_الـ_Secret_Key";

  // 2. Customer ID (For Testing - In real app, get from Auth)
  static const String testCustomerId = "ضع_هنا_الـ_Customer_ID";

  // 3. Apple Pay Configuration (iOS)
  static const String merchantIdentifier = "merchant.com.youratpp.name";
  static const String applePayCountryCode = "US";

  // 4. Google Pay Configuration (Android)
  static const String googlePayCountryCode = "US";
  static const bool isGooglePayTestEnv = true;
}
