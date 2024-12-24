import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:todo_application/api/api.dart';
import 'package:todo_application/authentication/authentication.dart';
import 'package:todo_application/storage/storage.dart';

final authenticationInitializationProvider = FutureProvider<AuthenticationInitialization>((ref) async {
  final secureStorage = ref.watch(storageProvider);

  final token = await secureStorage.read(key: 'accessToken');
  final name = await secureStorage.read(key: 'name');
  final email = await secureStorage.read(key: 'email');
  final id = await secureStorage.read(key: 'id');

  final authenticationState = token != null && name != null && email != null && id != null
      ? AuthenticationState.authenticated(
          authenticatedUser: User(
            id: id,
            name: name,
            email: email,
            accessToken: token,
          ),
        )
      : const AuthenticationState.unAuthenticated();

  final apiCalls = ApiCalls(secureStorage: secureStorage);

  return AuthenticationInitialization(
    secureStorage: secureStorage,
    apiCalls: apiCalls,
    authenticationState: authenticationState,
  );
});

class AuthenticationInitialization {
  final FlutterSecureStorage secureStorage;
  final ApiCalls apiCalls;
  final AuthenticationState authenticationState;

  AuthenticationInitialization({
    required this.secureStorage,
    required this.apiCalls,
    required this.authenticationState,
  });
}

final authenticationControllerProvider = StateNotifierProvider<AuthenticationController, AuthenticationState>((ref) {
  final initialization = ref.watch(authenticationInitializationProvider);

  final authController = initialization.maybeWhen(
    orElse: () {
      final secureStorage = ref.watch(storageProvider);
      final apiCalls = ApiCalls(secureStorage: secureStorage);

      return AuthenticationController(
        secureStorage: secureStorage,
        apiCalls: apiCalls,
        authenticationState: const AuthenticationState.unAuthenticated(),
      );
    },
    data: (state) => AuthenticationController(
      secureStorage: state.secureStorage,
      apiCalls: state.apiCalls,
      authenticationState: state.authenticationState,
    ),
  );

  return authController;
});

class AuthenticationController extends StateNotifier<AuthenticationState> {
  late final FormGroup formGroup;
  final FlutterSecureStorage secureStorage;
  final ApiCalls apiCalls;
  final AuthenticationState authenticationState;

  AuthenticationController({
    required this.secureStorage,
    required this.apiCalls,
    required this.authenticationState,
  }) : super(authenticationState) {
    formGroup = FormGroup(
      {
        'email': FormControl<String>(
          validators: [
            Validators.required,
            Validators.email,
          ],
        ),
        'password': FormControl<String>(
          validators: [
            Validators.required,
          ],
        ),
        'name': FormControl<String>(
          validators: [
            Validators.required,
          ],
        ),
      },
    );
  }

  Future<void> login() async {
    final email = formGroup.control('email').value;
    final password = formGroup.control('password').value;

    try {
      final user = await apiCalls.loginUser(email, password);

      await secureStorage.write(key: 'accessToken', value: user.accessToken);
      await secureStorage.write(key: 'name', value: user.name);
      await secureStorage.write(key: 'email', value: user.email);
      await secureStorage.write(key: 'id', value: user.id);

      state = AuthenticationState.authenticated(
        authenticatedUser: User(
          id: user.id,
          name: user.name,
          email: user.email,
          accessToken: user.accessToken,
        ),
      );
    } catch (e) {
      state = const AuthenticationState.unAuthenticated();
    }
  }

  Future<void> signup() async {
    final email = formGroup.control('email').value;
    final password = formGroup.control('password').value;
    final name = formGroup.control('name').value;

    try {
      final user = await apiCalls.registerUser(email, password, name);

      await secureStorage.write(key: 'accessToken', value: user.accessToken);
      await secureStorage.write(key: 'name', value: user.name);
      await secureStorage.write(key: 'email', value: user.email);
      await secureStorage.write(key: 'id', value: user.id);

      state = AuthenticationState.authenticated(
        authenticatedUser: User(
          id: user.id,
          name: user.name,
          email: user.email,
          accessToken: user.accessToken,
        ),
      );
    } catch (e) {
      state = const AuthenticationState.unAuthenticated();
    }
  }

  Future<void> logout() async {
    await secureStorage.delete(key: 'accessToken');
    await secureStorage.delete(key: 'name');
    await secureStorage.delete(key: 'email');
    await secureStorage.delete(key: 'id');

    state = const AuthenticationState.unAuthenticated();
  }
}
