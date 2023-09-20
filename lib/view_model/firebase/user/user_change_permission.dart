
import 'dart:developer';
import 'dart:io';
import 'package:meeting_room/model/user_info.dart';
import 'package:meeting_room/view_model/firebase/firebase_config.dart';

class UserChangePermissionApi{
  Future<bool> postUserChangPermission({required UserInfo userInfo, required int permissionInt}) async {
    try {
      if (Platform.isWindows) {
        final docRef = FirebaseConfigForWindows().userDirection.document(userInfo.email);
        await docRef.update({
          "permission": permissionInt,
        });
        return true;
      } else {
        final docRef = FirebaseConfig().userDirection.doc(userInfo.email);
        await docRef.update({
          "permission": permissionInt,
        });
        return true;
      }
    } catch(e) {
      log('========== postUserChangPermission Error: $e ==========');
      return false;
    }

  }
}