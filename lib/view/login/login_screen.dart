import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeting_room/common/util/toast.dart';
import 'package:meeting_room/common/validator.dart';
import 'package:meeting_room/view/login/login_screen_controller.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final viewModel = context.read<LoginScreenController>();
      viewModel.checkAutoLogin().then((value) => value
          ? Future.delayed(const Duration(milliseconds : 500),() {
              context.go('/home');
          })
          : null);
    });

  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginScreenController>
        (builder: (BuildContext context, controller, Widget? child) {
        return Stack(
          children: [
            GestureDetector(
              onTap: (){
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/background.png'),
                                fit: BoxFit.fill)),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 30,
                              width: 80,
                              height: 200,
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                        AssetImage('assets/images/light-1.png'))),
                              ),
                            ),
                            Positioned(
                              left: 140,
                              width: 80,
                              height: 150,
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                        AssetImage('assets/images/light-2.png'))),
                              ),
                            ),
                            Positioned(
                              right: 40,
                              top: 40,
                              width: 80,
                              height: 150,
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/images/clock.png'))),
                              ),
                            ),
                            Positioned(
                              child: Container(
                                margin: const EdgeInsets.only(top: 50),
                                child: const Center(
                                  child: Text(
                                    "코어닥스 회의실",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color:  Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                        blurRadius: 20.0,
                                        spreadRadius: 2.0,
                                    )
                                  ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(color: Colors.grey))),
                                    child: TextFormField(
                                      controller: controller.email,
                                      validator: (value) => Validator().emailValidator(value),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "이메일",
                                          hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: controller.password,
                                      obscureText: true,
                                      validator: (value) => Validator().passwordValidator(value),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "비밀번호",
                                          hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            InkWell(
                              onTap: () async {
                                if(controller.formKey.currentState!.validate()){
                                  await controller.login(emailSaved: controller.email.text.trim()).then((result) {
                                    if(result){
                                      context.go('/home');
                                    } else {
                                      showNegativeToast(context: context, text: controller.errorString);
                                    }
                                  });
                                }
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.06,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(colors: [
                                      Theme.of(context).colorScheme.primary.withOpacity(1),
                                      Theme.of(context).colorScheme.primary.withOpacity(0.6),
                                    ]),
                                ),
                                child: const Center(
                                  child: Text(
                                    "로그인",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                        value: controller.isAutoLoginChecked,
                                        activeColor: Theme.of(context).colorScheme.primary,
                                        // activeColor: const Color.fromRGBO(143, 148, 251, 1),
                                        side: MaterialStateBorderSide.resolveWith(
                                              (states) => BorderSide(width: 1.0, color: Theme.of(context).colorScheme.primary,),
                                              // (states) => const BorderSide(width: 1.0, color: Color.fromRGBO(143, 148, 251, 1)),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            controller.isAutoLoginChecked = value!;
                                          });
                                        }
                                    ),
                                    Text(
                                      "자동 로그인",
                                      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 14),
                                      // style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1), fontSize: 14),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: (){
                                    context.push('/signin');
                                  },
                                  child: Text(
                                    "회원가입",
                                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16),
                                    // style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1), fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            controller.isLoading
                ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.2),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('자동 로그인 중.....', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                ],
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
