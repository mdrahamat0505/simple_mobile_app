part of 'user_profile_update_bloc.dart';

abstract class UserProfileUpdateEvent extends Equatable {
  const UserProfileUpdateEvent();

  @override
  List<Object> get props => [];
}

class usernameChanged extends UserProfileUpdateEvent {
  const usernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class firstNameChanged extends UserProfileUpdateEvent {
  const firstNameChanged(this.firstName);

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

class lastNameChanged extends UserProfileUpdateEvent {
  const lastNameChanged(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

class passwordChanged extends UserProfileUpdateEvent {
  const passwordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class emailChanged extends UserProfileUpdateEvent {
  const emailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class ProfileUpdateSubmitted extends UserProfileUpdateEvent {}
