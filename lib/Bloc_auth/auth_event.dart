abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {

  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});
}

class RegisterSubmitted extends AuthEvent {
  final String fullName;
  final String phone;
  final String email;
  final String password;
  final int birthYear;
  final String gender;
  final String avatar;

  RegisterSubmitted({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
    required this.birthYear,
    required this.gender,
    required this.avatar,
  });
}
class LogoutEvent extends AuthEvent {}