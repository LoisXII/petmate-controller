enum UserLoginStatusEnum {
  user_notfound,
  password_notmatch,
  user_found_password_match,
  error,
}

class UserLoginModel {
  String? user_id;
  String email;
  String? password;
  bool exists;
  UserLoginStatusEnum user_login_status_enum;

  UserLoginModel({
    required this.email,
    required this.exists,
    required this.user_login_status_enum,
    this.user_id,
    this.password,
  });
}
