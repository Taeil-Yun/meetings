import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meeting_room/view_model/firebase/user/user_api.dart';


class SignInScreenController extends ChangeNotifier{

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);


  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password2 = TextEditingController();
  TextEditingController name = TextEditingController();

  String selectedPosition = '책임';
  List<String> listPosition = ['이사', '본부장', '책임', '주임', '시원', '연구원'];


  Future<bool> checkUser() async {
    bool check = await UserApi().checkUser(userId: email.text.trim());
    // false 일때는 유저의 아이디가 없슴
    return check;
  }

  Future<bool> trySignIn() async {
    // true 일때 저장 완료
    bool trySignIn = await UserApi().signInUser(userId: email.text.trim(), userPassword: password.text, userName: "${name.text} $selectedPosition");
    return trySignIn;
  }
}