import 'dart:convert';

import 'package:http/http.dart';

class HttpHelper {
  Future<dynamic> getData(String _url, dynamic _body) async {
    var responseJson;

    try {
      Uri url = Uri.parse(_url);
      var headers = {
        "Content-type": "application/x-www-form-urlencoded",
      };

      final response = await post(url, headers: headers);
      responseJson = _returnResponse(response);
    } catch (e) {
      print('No net');
    }
    return responseJson;
  }

  Future<dynamic> postData(String _url, dynamic _body) async {
    var _responseJson;

    try {
      Uri url = Uri.parse(_url);
      var headers = {
        "Content-type": "application/json",
      };

      var response = await post(url, headers: headers, body: _body);
      _responseJson = _returnResponse(response);
    } catch (e) {
      print('No net');
    }
    return _responseJson;
  }

  Future<dynamic> postUpdateData(String _url, Map<String, String> data) async {
    var responseJson;

    final String POST_METHOD = 'POST';
    try {
      await data.forEach((key, value) {});
      var request = MultipartRequest(POST_METHOD, Uri.parse(_url));
      request.fields.addAll(data);

      responseJson = await request.send();
      responseJson = await Response.fromStream(responseJson);
      responseJson = _returnResponse(responseJson);
    } catch (e) {
      print('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 301:
        try {
          Map<dynamic, dynamic> responseJson = json.decode(response.body);
          var data = responseJson['message'];
          print("error:" + data);
        } catch (e) {}
        break;
      case 400:
        try {
          Map<dynamic, dynamic> responseJson = json.decode(response.body);
          var data = responseJson['message'];
          print("error:" + data);
        } catch (e) {}
        break;
      case 412:
        return response;
        break;
      case 401:
        try {
          Map<dynamic, dynamic> responseJson = json.decode(response.body);
          var data = responseJson['message'];
          print("error:" + data);
        } catch (e) {}
        break;
      case 403:
        try {
          Map<dynamic, dynamic> responseJson = json.decode(response.body);
          var data = responseJson['message'];
          print("error:" + data);
        } catch (e) {}
        break;
      case 404:
        try {
          Map<dynamic, dynamic> responseJson = json.decode(response.body);
          var data = responseJson['message'];
          print("error:" + data);
        } catch (e) {}
        break;
      case 500:
        try {
          Map<dynamic, dynamic> responseJson = json.decode(response.body);
          var data = responseJson['message'];
          print("error:" + data);
        } catch (e) {}
        break;
      default:
        Map<dynamic, dynamic> responseJson = json.decode(response.body);
        var data = responseJson['message'];
        print("error:" + data.toString());
    }
  }
}
