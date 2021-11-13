part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class usernameChanged extends SignUpEvent {
  const usernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class firstNameChanged extends SignUpEvent {
  const firstNameChanged(this.firstName);

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

class lastNameChanged extends SignUpEvent {
  const lastNameChanged(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

class passwordChanged extends SignUpEvent {
  const passwordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class emailChanged extends SignUpEvent {
  const emailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class Submitted extends SignUpEvent {}
