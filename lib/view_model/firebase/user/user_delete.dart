
import 'dart:developer';
import 'dart:io';
import 'package:meeting_room/view_model/firebase/firebase_config.dart';

class UserDeleteApi{
  Future<bool> postUserDelete({required String userEmail}) async {
    try {
      dynamic docRef;

      if (Platform.isWindows) {
        docRef = FirebaseConfigForWindows().userDirection.document(userEmail);
      } else {
        docRef = FirebaseConfig().userDirection.doc(userEmail);
      }

      await docRef.delete();
      log('========== postUserDelete OK ==========');
      return true;
    } catch(e) {
      log('========== getUserList Error: $e ==========');
      return false;
    }

  }
}