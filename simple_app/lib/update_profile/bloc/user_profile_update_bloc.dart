import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/model/user_model.dart';
import 'package:simple_app/service/http_helper.dart';

part 'user_profile_update_event.dart';
part 'user_profile_update_state.dart';

class UserProfileUpdateBloc
    extends Bloc<UserProfileUpdateEvent, UserProfileUpdateState> {
  HttpHelper _helper;
  SharedPreferences _prefer;

  UserProfileUpdateBloc() : super(const UserProfileUpdateState()) {
    _helper = HttpHelper();
  }

  @override
  Stream<UserProfileUpdateState> mapEventToState(
      UserProfileUpdateEvent event) async* {
    if (event is ProfileUpdateSubmitted) {
      yield* _mapProfileUpdateSubmittedToState(event, state);
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

  UserProfileUpdateState _mapUsernameChangedToState(
    usernameChanged event,
    UserProfileUpdateState state,
  ) {
    return state.copyWith(
      username: event.username,
    );
  }

  UserProfileUpdateState _mapfirstNameChangedToState(
    firstNameChanged event,
    UserProfileUpdateState state,
  ) {
    return state.copyWith(
      username: event.firstName,
    );
  }

  UserProfileUpdateState _maplastNameChangedToState(
    lastNameChanged event,
    UserProfileUpdateState state,
  ) {
    return state.copyWith(
      username: event.lastName,
    );
  }

  UserProfileUpdateState _mapPasswordChangedToState(
    passwordChanged event,
    UserProfileUpdateState state,
  ) {
    return state.copyWith(
      password: event.password,
    );
  }

  UserProfileUpdateState _mapEmailChangedToState(
    emailChanged event,
    UserProfileUpdateState state,
  ) {
    return state.copyWith(
      email: event.email,
    );
  }

  Stream<UserProfileUpdateState> _mapProfileUpdateSubmittedToState(
    ProfileUpdateSubmitted event,
    UserProfileUpdateState state,
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

      //dynamic body = json.encode(data);
      try {
        _prefer.setString('USERNAME', state.username ?? '') as String;
        _prefer.setString('PASSWORD', state.password ?? '') as String;
      } catch (e) {}
      final response = await _helper.postUpdateData(_url, data);
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
          //Map<dynamic, dynamic> responseJson = json.decode(response.body);
          //var data = responseJson['data'];
          UserModel user = UserModel.fromJson(responseJson);

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
