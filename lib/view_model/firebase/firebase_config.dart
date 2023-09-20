import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firestore/firestore.dart' as fs;
import 'package:firedart/firestore/models.dart' as fsm;

class FirebaseInstanceConfig {
  /// Android, iOS, MacOS 용 firebase store instance
  FirebaseFirestore fbFirestore() {
    return FirebaseFirestore.instance;
  }

  /// Windows 용 firebase store instance
  fs.Firestore fsFirestore() {
    return fs.Firestore.instance;
  }
}

/// Android, iOS, MacOS 용
class FirebaseConfig {

  var baseFirebase = FirebaseInstanceConfig().fbFirestore().collection("coredax");

  var userDirection = FirebaseInstanceConfig().fbFirestore().collection("coredax").doc("users").collection("user");

  DocumentReference<Map<String, dynamic>> roomDirection = FirebaseInstanceConfig().fbFirestore().collection('coredax').doc('room');
}

/// Windows 용
class FirebaseConfigForWindows{
  var baseFirebase = FirebaseInstanceConfig().fsFirestore().collection('coredax');

  var userDirection = FirebaseInstanceConfig().fsFirestore().collection("coredax").document("users").collection("user");

  fsm.DocumentReference roomDirection = FirebaseInstanceConfig().fsFirestore().collection('coredax').document('room');
}