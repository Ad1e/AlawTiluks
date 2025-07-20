import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  static void uploadSensorData({
    required double gas,
    required double smoke,
    required double temp,
    required double humidity,
  }) {
    FirebaseFirestore.instance.collection('sensor_data').add({
      'gas': gas,
      'smoke': smoke,
      'temperature': temp,
      'humidity': humidity,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static void logEvent(String message, {String level = 'info'}) {
    FirebaseFirestore.instance.collection('logs').add({
      'message': message,
      'level': level,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
