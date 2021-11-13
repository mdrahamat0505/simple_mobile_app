part of 'user_profile_update_bloc.dart';

class UserProfileUpdateState extends Equatable {
  final FormzStatus status;
  final String firstName;
  final String lastName;
  final String username;
  final String password;
  final String email;
  final String message;
  final String token;
  final UserModel userModel;

  const UserProfileUpdateState({
    this.status = FormzStatus.pure,
    this.username,
    this.firstName,
    this.lastName,
    this.password,
    this.email,
    this.message,
    this.token,
    this.userModel,
  });

  UserProfileUpdateState copyWith({
    FormzStatus status,
    String username,
    String firstName,
    String lastName,
    String email,
    String password,
    String message,
    String token,
    UserModel userModel,
  }) {
    return UserProfileUpdateState(
      status: status ?? this.status,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      email: email ?? this.email,
      token: token ?? this.token,
      message: message ?? this.message,
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  List<dynamic> get props => [
        status,
        username,
        firstName,
        lastName,
        password,
        email,
        message,
        userModel,
      ];
}
