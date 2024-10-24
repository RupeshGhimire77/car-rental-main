import 'dart:ffi';

class User1 {
  String? id;
  String? name;
  String? role;
  String? email;
  String? password;
  String? confirmPassword;
  String? mobileNumber;

  User1(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.confirmPassword,
      this.role,
      this.mobileNumber});

  User1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
    mobileNumber = json['mobileNumber'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['confirmPassword'] = this.confirmPassword;
    data['mobileNumber'] = this.mobileNumber;
    data['role'] = this.role;
    return data;
  }
}
