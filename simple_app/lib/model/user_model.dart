import 'dart:convert';

UserResponseModel userResponseFromJson(String str) =>
    UserResponseModel.fromJson(json.decode(str));

class UserModel {
  String userName;
  String firstName;
  String lastName;
  String email;
  String password;
  String confirmPassword;

  UserModel({
    this.userName,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.confirmPassword,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userName = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['username'] = userName;
    data['last_name'] = firstName;
    data['first_name'] = lastName;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}

class UserResponseModel {
  int code;
  String message;

  UserResponseModel({this.code, this.message});

  UserResponseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}
