import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeting_room/common/convert_password.dart';
import 'package:meeting_room/main.dart';
import 'package:meeting_room/model/user_info.dart';
import 'package:meeting_room/view_model/firebase/firebase_config.dart';
import 'package:meeting_room/view_model/firebase/user/user_api.dart';
import 'package:meeting_room/view_model/firebase/user/user_change_permission.dart';

class LoginScreenController extends ChangeNotifier{

  final formKey = GlobalKey<FormState>();


  bool isLoading = true;
  bool isAutoLoginChecked = false;

  bool isDarkMode = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  UserInfo? userInfo;
  StreamSubscription<DocumentSnapshot>? userStream;
  StreamSubscription<dynamic>? userStreamForWindows;

  String errorString = '';

  // 최고 관리자 용
  List<UserInfo> usersList = [];
  List<String> listPosition = ['최고관리자', '관리자', '사용자'];
  List<String> optionPosition = ['관리자', '사용자'];
  StreamSubscription<QuerySnapshot>? listenerStream;
  StreamSubscription<dynamic>? listenerStreamForWindows;

  Future<bool> checkAutoLogin() async {
    isLoading = true;
    // logOut();
    notifyListeners();
    String? userLoginState = await secureStorage.read(key: 'autoLogin');
    String? userEmailState = await secureStorage.read(key: 'email');
    String? userPasswordState = await secureStorage.read(key: 'password');


    String? themType = await secureStorage.read(key: 'themeType');

    if (themType != null && themType == 'light') {
      isDarkMode = false;
      notifyListeners();
    } else if (themType != null && themType == 'dark') {
      isDarkMode = true;
      notifyListeners();
    } else {
      notifyListeners();
    }

    if (userLoginState != null && userLoginState == 'true' && userEmailState != null && userPasswordState != null){
      login(emailSaved: userEmailState, passwordSaved: userPasswordState);
      return true;
    } else if (userLoginState != null && userLoginState == 'true' && (userEmailState == null || userPasswordState == null)){
      isAutoLoginChecked = true;
      isLoading = false;
      notifyListeners();
      return false;
    } else {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }


  Future<bool> login({required String emailSaved, String? passwordSaved}) async {
    log('======= login ========');
    isLoading = true;
    usersList = [];
    notifyListeners();

    // 암호화
    String protectPassword = passwordSaved ?? convertToHash(password.text.trim());
    Map<String, dynamic> result = await UserApi().loginUser(userId: emailSaved, userPassword: protectPassword);
    if (result['error'] == '0') {
      if (Platform.isWindows) {
        final userInfoWatch = FirebaseConfigForWindows().userDirection.document(emailSaved);
        userStreamForWindows = userInfoWatch.stream.listen((event) async {
          log('============ login result ==============');
          Map<String, dynamic> resultMap = event?.map ?? {};

          userInfo = UserInfo.name(event!.id, resultMap['user_password'], resultMap['name'], resultMap['permission']);
          notifyListeners();

          if(isAutoLoginChecked) {
            await secureStorage.write(key: 'autoLogin', value: isAutoLoginChecked.toString());
            await secureStorage.write(key: 'email', value: event.id);
            await secureStorage.write(key: 'password', value: resultMap['user_password']);
            await secureStorage.write(key: 'name', value: resultMap['name']);
          }
        },
          onError: (e) => log('============ login error $e =============='),
        );
      } else {
        final userInfoWatch = FirebaseConfig().userDirection.doc(emailSaved);
        userStream = userInfoWatch.snapshots().listen((event) async {
          log('============ login result ==============');
          Map<String, dynamic> resultMap = event.data() ?? {};

          userInfo = UserInfo.name(event.id, resultMap['user_password'], resultMap['name'], resultMap['permission']);
          notifyListeners();

          if(isAutoLoginChecked){
            await secureStorage.write(key: 'autoLogin', value: isAutoLoginChecked.toString());
            await secureStorage.write(key: 'email', value: event.id);
            await secureStorage.write(key: 'password', value: resultMap['user_password']);
            await secureStorage.write(key: 'name', value: resultMap['name']);
          }
        },
          onError: (e) => log('============ login error $e =============='),
        );
      }

      email.text = '';
      password.text = '';
      notifyListeners();

      isLoading = false;
      notifyListeners();
      return true;
    } else {
      errorString = result['error'];
      isLoading = false;
      notifyListeners();
      return false;
    }
  }


  Future<void> logOut() async {
    // await secureStorage.delete(key: 'autoLogin');
    disposeForAdmin();
    if (Platform.isWindows) {
      userStreamForWindows?.cancel();
    } else {
      userStream?.cancel();
    }
    await secureStorage.delete(key: 'email');
    await secureStorage.delete(key: 'password');
    await secureStorage.delete(key: 'name');
  }


  // setting page 쪽
  // 다크 모드
  // TODO: 로그인 페이지 다크 모드 색상 적용 필요
  Future<void> changeThemeInMain(BuildContext context, bool modeStateDark)  async {
    isDarkMode = modeStateDark;
    if(modeStateDark){
      await secureStorage.write(key: 'themeType', value: 'dark');
      MyApp.of(context).changeTheme(ThemeMode.dark);
    } else {
      await secureStorage.write(key: 'themeType', value: 'light');
      MyApp.of(context).changeTheme(ThemeMode.light);
    }
    notifyListeners();
  }

  // // 관리자 유저리스트 권한용 유저 리스트 가져오기
  // Future<void> getUserList() async {
  //   List<UserInfo> userinfoList = await UserListApi().getUserList();
  //
  //   if(userinfoList.isNotEmpty){
  //     usersList = [];
  //     usersList.addAll(userinfoList);
  //   }
  // }

  Future<void> addListenerToUser() async {
    dynamic docRef;

    if (Platform.isWindows) {
      listenerStreamForWindows = FirebaseConfigForWindows().userDirection.stream.listen((event) {
        List<UserInfo> userData = [];

        for (var change in event) {
          if (userData.contains(UserInfo.name(change.id, change['user_password'], change['name'], change['permission'])) == false) {
            log('============ getDataAboutRoom listen ==============');
            log("신규 : $userData");
            userData.add(UserInfo.name(change.id, change['user_password'], change['name'], change['permission']));
            userData.sort((a, b) => a.permission.compareTo(b.permission));
            usersList = userData;
            notifyListeners();
          }
        }
      },
        onError: (error) => log("Listen failed: $error"),
      );
    } else {
      docRef = FirebaseConfig().userDirection;

      listenerStream = docRef.snapshots().listen((event) {
        for (var change in event.docChanges) {
          switch (change.type) {
          // 추가 이벤트
            case DocumentChangeType.added:
              log('============ getDataAboutRoom listen ==============');
              log("신규 : ${change.doc.data()}");
              usersList.add(
                  UserInfo.name(change.doc.id, change.doc['user_password'], change.doc['name'], change.doc['permission']));
              usersList.sort((a, b) => a.permission.compareTo(b.permission));
              notifyListeners();
              break;
          // 수정 이벤트
            case DocumentChangeType.modified:
              log('============ getDataAboutRoom listen ==============');
              log("수정 : ${change.doc.data()}");
              usersList.removeWhere((element) => element.email == change.doc.id);
              usersList.add(
                  UserInfo.name(change.doc.id, change.doc['user_password'], change.doc['name'], change.doc['permission']));
              usersList.sort((a, b) => a.permission.compareTo(b.permission));
              notifyListeners();
              break;
            case DocumentChangeType.removed:
              log('============ getDataAboutRoom listen ==============');
              log("삭제 : ${change.doc.data()}");
              usersList.removeWhere((element) => element.email == change.doc.id);
              notifyListeners();
              break;
          }
        }
      },
        onError: (error) => log("Listen failed: $error"),
      );
    }
  }

  Future<bool> onChangePosition({required UserInfo selectedUserInfo, required String changePosition}) async {
    if(listPosition[selectedUserInfo.permission] != changePosition){
      int positionNum = changePosition == '사용자' ? 2 : 1;
      bool result = await UserChangePermissionApi().postUserChangPermission(userInfo: selectedUserInfo, permissionInt: positionNum);
      return result;
    } else {
      return false;
    }
  }

  Future<void> disposeForAdmin() async {
    if (Platform.isWindows) {
      listenerStreamForWindows?.cancel();
    } else {
      listenerStream?.cancel();
    }
    usersList = [];
    notifyListeners();
  }

}