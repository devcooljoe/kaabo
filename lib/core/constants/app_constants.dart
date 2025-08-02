class AppConstants {
  static const String appName = 'Kaabo';

  static const List<String> supportedLanguages = [
    'en',
    'pcm',
    'ha',
    'yo',
    'ig',
  ];
  static const String defaultLanguage = 'en';

  static const Map<String, Map<String, double>> universities = {
    'University of Ibadan': {'lat': 7.3775, 'lng': 3.9470},
    'University of Lagos': {'lat': 6.5158, 'lng': 3.3900},
    'Obafemi Awolowo University': {'lat': 7.5227, 'lng': 4.5194},
    'University of Nigeria Nsukka': {'lat': 6.8747, 'lng': 7.4056},
    'Ahmadu Bello University': {'lat': 11.1667, 'lng': 7.6333},
    'University of Benin': {'lat': 6.4000, 'lng': 5.6037},
    'Federal University of Technology Akure': {'lat': 7.3000, 'lng': 5.1500},
    'Lagos State University': {'lat': 6.5833, 'lng': 3.3667},
    'Covenant University': {'lat': 6.6719, 'lng': 3.1592},
    'Babcock University': {'lat': 6.8947, 'lng': 3.7094},
  };

  static const double campusProximityRadius = 5.0;

  static const double maxRating = 5.0;
  static const int minReviewLength = 10;
}
