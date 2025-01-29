abstract class LoginState {}
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final String token;
  LoginSuccess(this.token);
}
class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
