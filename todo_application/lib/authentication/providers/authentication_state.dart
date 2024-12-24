import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_application/authentication/authentication.dart';

part 'authentication_state.freezed.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.authenticated({required User authenticatedUser}) = _Authenticated;

  const factory AuthenticationState.unAuthenticated() = _UnAuthenticated;
}
