class UserInfo {
  UserInfo();

  UserInfo.name(this.email, this.password, this.name, this.permission);

  String email = '';
  String password = '';
  String name = '';
  int permission = 2;

  @override
  String toString() {
    return 'UserInfo{email: $email, password: $password, name: $name, permission: $permission}';
  }

  Map<String, Object> convertMap() {
    final Map<String, Object> autoLoginData = <String, Object>{
      'email': email,
      'password': password,
      'name': name,
      'permission' : permission
    };
    return autoLoginData;
  }

  bool hasLoginInfo() {
    return email.isNotEmpty && password.isNotEmpty && name.isNotEmpty;
  }
}
