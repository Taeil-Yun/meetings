import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room/common/util/toast.dart';
import 'package:meeting_room/view/login/login_screen_controller.dart';
import 'package:meeting_room/view/widget/dialogs.dart';
import 'package:meeting_room/view_model/firebase/user/user_delete.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<LoginScreenController>();
    if(viewModel.userInfo != null && viewModel.userInfo!.permission == 0){
      viewModel.addListenerToUser();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        leading: IconButton(
          onPressed: () {
            context.read<LoginScreenController>().disposeForAdmin().then((value) {
              context.pop();
            });
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Consumer<LoginScreenController>(
        builder: (BuildContext context, controller, Widget? child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  userInfo(title: '이름', subTitle: controller.userInfo?.name ?? ''),
                  userInfo(title: '이메일', subTitle: controller.userInfo?.email ?? ''),
                  userInfo(
                      title: '다크 모드',
                      subTitle: '',
                      subWidget: CupertinoSwitch(
                        value: controller.isDarkMode,
                        onChanged: (value) {
                          controller.changeThemeInMain(context, value);
                        },
                      ),
                  ),
                  if(controller.userInfo != null && controller.userInfo!.permission == 0 && controller.usersList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: forHighPermissionUser(
                          title: '사용자 권한',
                          subWidget: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.usersList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        controller.usersList[index].name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                    ),
                                    controller.usersList[index].permission != 0
                                        ? SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.2,
                                            child: DropdownButtonFormField(
                                              decoration: const InputDecoration(
                                                isDense: true,
                                                contentPadding: EdgeInsets.all(0),
                                              ),
                                              // style: TextStyle(fontSize: 14),
                                              value: controller.listPosition[controller.usersList[index].permission],
                                              items: controller.optionPosition.map((String item) {
                                                return DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(item),
                                                );
                                              }).toList(),
                                              onChanged: (String? value) {
                                                print('value $value');
                                                controller.onChangePosition(selectedUserInfo: controller.usersList[index], changePosition: value!);
                                              },
                                            ),
                                          )
                                        : Text(controller.listPosition[controller.usersList[index].permission]),
                                  ],
                                ),
                              );
                            },
                          ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: InkWell(
                      onTap: () async {
                        controller.logOut().then((value) => GoRouter.of(context).pushReplacement('/'));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            gradient: LinearGradient(colors: [
                              Theme.of(context).colorScheme.primary.withOpacity(1),
                              Theme.of(context).colorScheme.primary.withOpacity(0.6),
                            ])),
                        child: const Center(
                          child: Text(
                            "로그아웃",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      showConfirmDialog(
                        context: context,
                        body: const Text('회원 탈퇴를 하시겠습니까?' , textAlign: TextAlign.center,),
                        positiveButtonText: '확인',
                        positiveButtonCallback: () async {
                          await UserDeleteApi().postUserDelete(userEmail: controller.userInfo!.email).then((value) {
                            if(value){
                              showNormalToast(context: context, text: '회원탈퇴 완료', );
                              controller.logOut().then((value) => GoRouter.of(context).pushReplacement('/'));
                            } else {
                              showNormalToast(context: context, text: '회원탈퇴가 실패 했습니다.', );
                            }
                          });
                        },
                        negativeButtonText: '취소',
                        negativeButtonCallback: () {
                          context.pop();
                        },
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey
                      ),
                      child: const Center(
                        child: Text(
                          "회원 탈퇴",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget userInfo({required String title, required String subTitle, Widget? subWidget}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      child:  Row(
        children: [
          Expanded(
            flex: 1,
              child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          ),
          Expanded(
            flex: 3,
            child: Container(
                alignment: Alignment.centerRight, child: subWidget ?? Text(subTitle, style: const TextStyle(fontSize: 14,),)),
          ),
        ],
      ),
    );
  }

  Widget forHighPermissionUser({required String title, required Widget subWidget}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
        ),
        Expanded(
          flex: 3,
          child: subWidget
        ),
      ],
    );
  }
}
