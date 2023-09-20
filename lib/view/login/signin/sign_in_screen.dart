
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room/common/util/toast.dart';
import 'package:meeting_room/common/validator.dart';
import 'package:meeting_room/view/login/signin/sign_in_screen_controller.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('회원 가입',),
      ),
      body: Consumer<SignInScreenController>(
        builder: (BuildContext context, controller, Widget? child) {
          return Stack(
            children: [
              GestureDetector(
                onTap: (){
                  FocusScope.of(context).unfocus();
                },
                child: Form(
                  key: controller.formKey,
                  child: Center(
                    child: ListView(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text('이메일 주소', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: TextFormField(
                            controller: controller.email,
                            validator: (value) => Validator().emailValidator(value),
                            style: controller.style,
                            decoration: InputDecoration(
                              // contentPadding: EdgeInsets.zero,
                              isDense: true,
                              prefixIcon: const Icon(Icons.email),
                              labelText: "이메일",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text('비밀번호', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: TextFormField(
                            obscureText: true,
                            controller: controller.password,
                            validator: (value) => Validator().passwordValidator(value),
                            style: controller.style,
                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: const Icon(Icons.lock),
                              labelText: "비밀번호",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: TextFormField(
                            obscureText: true,
                            controller: controller.password2,
                            validator: (val) {
                              if(val == null || val == ''){
                                return "패스워드 확인을 해 주세요.";
                              } else if(val != controller.password.text){
                                return "패스워드가 다릅니다";
                              } else {
                                return null;
                              }
                            },
                            style: controller.style,
                            decoration: InputDecoration(
                              isDense: true,
                              prefixIcon: Icon(Icons.lock),
                              labelText: "비밀번호 확인",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text('직책', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            value: controller.selectedPosition,
                            items: controller.listPosition.map((String item) {
                              return DropdownMenuItem<String>(
                                child: Text('$item'),
                                value: item,
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                controller.selectedPosition = value!;
                              });
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text('이름', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: TextFormField(
                            controller: controller.name,
                            validator: (value) => Validator().nameValidator(value),
                            style: controller.style,
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: "이름",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              if(controller.formKey.currentState!.validate()){
                                setState(() {
                                  controller.isLoading = true;
                                });
                                await controller.checkUser().then((result) async {
                                  if(result){
                                    setState(() {
                                      controller.isLoading = false;
                                    });
                                    showNegativeToast(context: context, text: '이미 아이디가 존재 합니다');
                                  } else {
                                    await controller.trySignIn().then((signInResult) {
                                      if(signInResult){
                                        showNormalToast(context: context, text: '회원가입이 완료 되었습니다.');
                                        setState(() {
                                          controller.isLoading = false;
                                        });
                                        context.pop();
                                      } else {
                                        setState(() {
                                          controller.isLoading = false;
                                        });
                                        showNegativeToast(context: context, text: '회원가입 도중 오류가 발생 하였습니다.');
                                      }
                                    });
                                  }
                                });
                              }
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  gradient: LinearGradient(colors: [
                                    Theme.of(context).colorScheme.primary.withOpacity(1),
                                    Theme.of(context).colorScheme.primary.withOpacity(0.6),
                                    // Color.fromRGBO(143, 148, 251, 1),
                                    // Color.fromRGBO(143, 148, 251, .6),
                                  ])),
                              child: const Center(
                                child: Text(
                                  "가입 하기",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              controller.isLoading
                  ? Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : Container(),
            ],
          );
        },
      ),
    );
  }
}
