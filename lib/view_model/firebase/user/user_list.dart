
import 'dart:developer';
import 'dart:io';
import 'package:meeting_room/model/user_info.dart';
import 'package:meeting_room/view_model/firebase/firebase_config.dart';

class UserListApi{
  Future<List<UserInfo>> getUserList() async {
    List<UserInfo> usersList = [];
    try {
      dynamic docRef;

      if (Platform.isWindows) {
        docRef = FirebaseConfigForWindows().userDirection;
      } else {
        docRef = FirebaseConfig().userDirection;
      }

      await docRef.get().then((value) {
        log('========== getUserList ==========');
        value.docs.forEach((e) {
          log('========== getUserList List: ${e.id} ==========');
          usersList.add(
              UserInfo.name(e.id, e['user_password'], e['name'], e['permission'])
          );
          log('========== getUserList List usersList: ${usersList.length} ==========');
        });
      });
      return usersList;
    } catch(e) {
      log('========== getUserList Error: $e ==========');
      return usersList;
    }

  }
}