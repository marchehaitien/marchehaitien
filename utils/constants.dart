import 'package:flutter/material.dart';

class Constants {
  static const String appName = 'Marché Haïtien';

  // Couleurs principales
  static const Color primaryColor = Colors.blueAccent;
  static const Color secondaryColor = Colors.orange;
  static const Color backgroundColor = Colors.black;
  static const Color whiteColor = Colors.white;

  // TextStyles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: whiteColor,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: whiteColor,
  );

  // Padding et Margins
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 40.0,
    vertical: 12.0,
  );
  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 12.0,
  );

  // Taille de logo
  static const double logoSize = 200.0;
  
  // Configuration Firebase
  static const String firebaseApiKey = 'YOUR_FIREBASE_API_KEY';
  static const String firebaseAuthDomain = 'YOUR_FIREBASE_AUTH_DOMAIN';
  static const String firebaseProjectId = 'YOUR_FIREBASE_PROJECT_ID';
  static const String firebaseStorageBucket = 'YOUR_FIREBASE_STORAGE_BUCKET';
  static const String firebaseMessagingSenderId = 'YOUR_FIREBASE_MESSAGING_SENDER_ID';
  static const String firebaseAppId = 'YOUR_FIREBASE_APP_ID';

  // Autres constantes utiles
  static const String defaultCountryCode = 'HT';
}
