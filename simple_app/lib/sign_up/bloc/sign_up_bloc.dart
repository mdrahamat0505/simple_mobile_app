import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/model/user_model.dart';
import 'package:simple_app/service/http_helper.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  HttpHelper _helper;
  SharedPreferences _prefer;
  SignUpBloc() : super(const SignUpState()) {
    _helper = HttpHelper();
  }

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is Submitted) {
      yield* _mapSubmittedToState(event, state);
    } else if (event is usernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is firstNameChanged) {
      yield _mapfirstNameChangedToState(event, state);
    } else if (event is lastNameChanged) {
      yield _maplastNameChangedToState(event, state);
    } else if (event is emailChanged) {
      yield _mapEmailChangedToState(event, state);
    } else if (event is passwordChanged) {
      yield _mapPasswordChangedToState(event, state);
    }
  }

  SignUpState _mapUsernameChangedToState(
    usernameChanged event,
    SignUpState state,
  ) {
    return state.copyWith(
      username: event.username,
    );
  }

  SignUpState _mapfirstNameChangedToState(
    firstNameChanged event,
    SignUpState state,
  ) {
    return state.copyWith(
      username: event.firstName,
    );
  }

  SignUpState _maplastNameChangedToState(
    lastNameChanged event,
    SignUpState state,
  ) {
    return state.copyWith(
      username: event.lastName,
    );
  }

  SignUpState _mapPasswordChangedToState(
    passwordChanged event,
    SignUpState state,
  ) {
    return state.copyWith(
      password: event.password,
    );
  }

  SignUpState _mapEmailChangedToState(
    emailChanged event,
    SignUpState state,
  ) {
    return state.copyWith(
      email: event.email,
    );
  }

  Stream<SignUpState> _mapSubmittedToState(
    Submitted event,
    SignUpState state,
  ) async* {
    try {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      final _url = 'http://apptest.dokandemo.com/wp-json/wp/v2/users/register';
      Map<String, dynamic> data = {};
      data['username'] = state.username ?? '';
      data['first_name'] = state.firstName ?? '';
      data['last_name'] = state.lastName ?? '';
      data['email'] = state.email ?? '';
      data['password'] = state.password ?? '';

      dynamic body = json.encode(data);
      try {
        _prefer.setString('USERNAME', state.username) as String;
        _prefer.setString('first_name', state.firstName ?? '') as String;
        _prefer.setString('last_name', state.lastName ?? '') as String;
        _prefer.setString('email', state.email) as String;
        _prefer.setString('PASSWORD', state.password) as String;
      } catch (e) {}

      final response = await _helper.postData(_url, data);
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
      }
      if (response.statusCode == 200) {
        try {
          var responseJson = json.decode(response.body);

          if (responseJson != null) {
            yield state.copyWith(
              status: FormzStatus.submissionSuccess,
              userModel: responseJson,
            );
          } else {
            yield state.copyWith(status: FormzStatus.submissionFailure);
          }
        } catch (e) {
          yield state.copyWith(status: FormzStatus.submissionFailure);
        }
      }
    } catch (e) {
      yield state.copyWith(status: FormzStatus.submissionCanceled);
    }
  }
}
