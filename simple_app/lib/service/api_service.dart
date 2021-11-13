import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:simple_app/model/user_model.dart';

class APIServices {
  static var client = http.Client();
  // static String apiURL = "http://192.168.0.103:8888/news-app";
  static String apiURL = "http://apptest.dokandemo.com";

  static Future<UserResponseModel> registerUser(
    UserModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
    };

    print(model.toJson());
    var response = await client.post(
      Uri.parse("$apiURL/wp-json/wp/v2/users/register"),
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    return userResponseFromJson(response.body);
  }
}
