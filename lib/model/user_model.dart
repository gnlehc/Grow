// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String email = "";
  String password = "";
  String tel = "";
  String username = "";
  double balance = 0.0;

  User({
    required this.email,
    required this.password,
    required this.tel,
    required this.username,
    required this.balance,
  });

  static User fromJson(Map<String, dynamic> json) => User(
      email: json['email'],
      password: json['password'],
      tel: json['telephoneNum'],
      username: json['username'],
      balance: json['balance']);
}
