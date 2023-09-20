class Validator {
  dynamic emailValidator(String? val){
    if(val == null || val == ''){
      return "이메일을 입력 해 주세요";
    }else if(!val.contains('@')){
      return "회사 이메일을 입력해 주세요";
    } else if(val.contains('@') && val.split('@').last != 'coredax.com'){
      return "회사 이메일을 입력해 주세요";
    } else {
      return null;
    }
  }

  dynamic passwordValidator(String? val){
    if(val == null || val == ''){
      return "패스워드를 입력 해 주세요";
    } else if(val.length < 8){
      return "패스워드를 8자이상 입력해주세요";
    } else {
      return null;
    }
  }

  dynamic nameValidator(String? val){
    if(val == null || val == ''){
      return "이름을 입력 해 주세요";
    } else {
      return null;
    }
  }

  /// 회의실 예약 타이틀 validator
  dynamic createRoomTitleValidator(String? val) {
    if (val == null || val.isEmpty) {
      return '회의 주제를 입력해주세요';
    } else {
      return null;
    }
  }

  /// 회의실 예약 날짜 validator
  dynamic createRoomDateValidator(String? val) {
    if (val == null || val.isEmpty) {
      return '회의 날짜를 선택해주세요';
    } else {
      return null;
    }
  }
  
  /// 회의실 예약 회의 시작 시각 validator
  dynamic createRoomStartTimeValidator(String? val) {
    if (val == null || val.isEmpty) {
      return '회의 시작 시각을 선택해주세요';
    } else {
      return null;
    }
  }

  /// 회의실 예약 회의 종료 시각 validator
  dynamic createRoomEndTimeValidator(String? val) {
    if (val == null || val.isEmpty) {
      return '회의 종료 시각을 선택해주세요';
    } else {
      return null;
    }
  }
}