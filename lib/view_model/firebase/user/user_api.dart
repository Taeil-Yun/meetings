import 'dart:developer';
import 'dart:io';

import 'package:meeting_room/common/convert_password.dart';
import 'package:meeting_room/view_model/firebase/firebase_config.dart';

class UserApi{

  // 유저 유무 확인
  Future<bool> checkUser({required String userId}) async {
    try {
      dynamic qs;

      if (Platform.isWindows) {
        qs = await FirebaseConfigForWindows().userDirection.get();
      } else {
        qs = await FirebaseConfig().userDirection.get();
      }

      log('========== checkUser Success ==========');
      if (qs.docs.isNotEmpty) {
        // user id 가 있을때
        if (qs.docs.where((element) => element.id == userId).isNotEmpty) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch(e) {
      log('========== checkUser Error ==========');
      log('========== error: $e =============');
      return false;
    }
  }

  // 유저 회원 가입
  Future<bool> signInUser({required String userId, required String userPassword, required String userName}) async {
    try {
      // 암호화
      String protectPassword = convertToHash(userPassword.trim());
      log('========== signInUser Success ==========');
      log('password: $userPassword, protectPassword: $protectPassword');

      // permission 2 == 최고, 1 == 관리자, 0 == 일반인
      try {
        if (Platform.isWindows) {
          await FirebaseConfigForWindows().userDirection.document(userId).set({
            "name": userName,
            "user_password": protectPassword,
            "permission" : 2,
          });
          return true;
        } else {
          await FirebaseConfig().userDirection.doc(userId).set({
            "name": userName,
            "user_password": protectPassword,
            "permission" : 2,
          });
          return true;
        }
      } catch (e){
        return false;
      }
    } catch(e) {
      log('========== signInUser Error ==========');
      log('========== error: $e =============');
      return false;
    }
  }

  // 유저 로그인
  Future<Map<String, dynamic>> loginUser({required String userId, required String userPassword}) async {
    try {
      dynamic result;
      
      if (Platform.isWindows) {
        result = await FirebaseConfigForWindows().userDirection.document(userId).get();
        if (result != null) {
          log('result $result');
          if(result['user_password'] == userPassword){
            log('========== loginUser Success ==========');
            log('loginUser name: ${result['name']}, user_password: ${result['user_password']}');
            return {
              "error" : '0',
              "email" :  userId,
              "password" :  result['user_password'],
              "name" :  result['name'],
              "permission" : result['permission']
            };
          } else {
            return {'error' : '비밀번호 오류'};
          }
        } else {
          return {'error' : '로그인 실패'};
        }
      } else {
        result = await FirebaseConfig().userDirection.doc(userId).get();

        if (result.exists) {
          log('result $result');
          if(result['user_password'] == userPassword){
            log('========== loginUser Success ==========');
            log('loginUser name: ${result['name']}, user_password: ${result['user_password']}');
            return {
              "error" : '0',
              "email" :  userId,
              "password" :  result['user_password'],
              "name" :  result['name'],
              "permission" : result['permission']
            };
          } else {
            return {'error' : '비밀번호 오류'};
          }
        } else {
          return {'error' : '로그인 실패'};
        }
      }
    } catch(e) {
      log('========== loginUser Error ==========');
      log('========== error: $e =============');
      return {'error' : '로그인 실패'};
    }
  }

}