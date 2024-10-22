abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String loginId;
  final String password;

  LoginButtonPressed(this.loginId, this.password);
}