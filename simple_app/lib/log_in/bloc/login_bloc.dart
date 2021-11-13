import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/model/user_model.dart';
import 'package:simple_app/service/http_helper.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  HttpHelper _helper;
  SharedPreferences _prefer;

  LoginBloc({HttpHelper helper}) : super(LoginState()) {
    _helper = HttpHelper();
    // _prefer = SharedPreferences.getInstance() as SharedPreferences;
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is submitted) {
      yield* _mapLoginSubmittedToState(event, state);
    }
  }

  LoginState _mapUsernameChangedToState(
    LoginUsernameChanged event,
    LoginState state,
  ) {
    return state.copyWith(
      username: event.username,
    );
  }

  LoginState _mapPasswordChangedToState(
    LoginPasswordChanged event,
    LoginState state,
  ) {
    return state.copyWith(
      password: event.password,
    );
  }

  Stream<LoginState> _mapLoginSubmittedToState(
    submitted event,
    LoginState state,
  ) async* {
    try {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      // const _url = 'http://apptest.dokandemo.com/wp-json/wp/v2/users/register';
      const _url = 'http://apptest.dokandemo.com/wp-json/jwt-auth/v1/token';
      var passwo = 'pas' + state.password;
      passwo = base64.encode(utf8.encode(passwo));
      UserModel userModel = UserModel();
      userModel.userName = state.username ?? _prefer.getString('USERNAME');
      userModel.password = passwo ?? _prefer.getString('PASSWORD');

      final String _body = userModel.toJson() as String;
      final Response response = await _helper.getData(_url, _body);

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        final data = responseJson['data'];

        final UserModel user = UserModel.fromJson(responseJson);

        try {
          _prefer.setString('USERNAME', state.username) as String;
          _prefer.setString('PASSWORD', state.password) as String;
        } catch (e) {}
        if (data != null) {
          yield state.copyWith(status: FormzStatus.submissionSuccess);
        }
      }
      if (response.statusCode == 404) {
        Map<dynamic, dynamic> responseJson = json.decode(response.body);
        var data = responseJson['message'];
        yield state.copyWith(
            status: FormzStatus.submissionFailure, message: data);
      }
      if (response.statusCode == 412) {
        Map<dynamic, dynamic> responseJson = json.decode(response.body);
        var data = responseJson['message'];
        yield state.copyWith(
            status: FormzStatus.submissionFailure, message: data);
      }
      if (response.statusCode == 500) {
        Map<dynamic, dynamic> responseJson = json.decode(response.body);
        var data = responseJson['message'];
        yield state.copyWith(
            status: FormzStatus.submissionFailure, message: data);
      } else {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    } catch (e) {
      yield state.copyWith(status: FormzStatus.submissionCanceled);
    }
  }
}
