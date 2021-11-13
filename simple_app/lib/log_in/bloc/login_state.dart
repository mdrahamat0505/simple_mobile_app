part of 'login_bloc.dart';

class LoginState extends Equatable {
  final FormzStatus status;
  final String username;
  final String password;
  final String message;
  final UserModel userModel;

  const LoginState({
    this.status = FormzStatus.pure,
    this.username,
    this.password,
    this.message,
    this.userModel,
  });

  LoginState copyWith({
    FormzStatus status,
    String username,
    String password,
    String message,
    UserModel userModel,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      message: message ?? this.message,
      userModel: userModel ?? this.userModel,
    );
  }

  @override
  List<Object> get props => [
        status,
        username,
        password,
        message,
        userModel,
      ];
}
