import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_application/authentication/authentication.dart';
import 'package:todo_application/authentication/view/sign_up.dart';
import 'package:todo_application/home/home.dart';

final appRouterProvider = Provider<AppRouter>((ref) {
  final authState = ref.watch(authenticationControllerProvider);

  return AppRouter(ref: ref, authenticationState: authState);
});

class AppRouter {
  final Ref ref;
  late final GoRouter router;
  final AuthenticationState authenticationState;

  // ignore: long-method
  AppRouter({
    required this.ref,
    required this.authenticationState,
  }) {
    router = GoRouter(
      initialLocation: authenticationState.when(
        authenticated: (_) => '/',
        unAuthenticated: () => '/login',
      ),
      debugLogDiagnostics: false,
      routes: [
        GoRoute(
          name: 'home',
          path: '/',
          builder: (context, state) {
            return const RemindersByDate();
          },
          routes: [
            GoRoute(
              name: 'create',
              path: 'create',
              builder: (context, state) {
                return const CreateReminder();
              },
            ),
            GoRoute(
              name: 'selectDate',
              path: 'selectDate',
              builder: (context, state) {
                return const SelectDatePage();
              },
            ),
            GoRoute(
              name: 'reminderDetail',
              path: 'reminderDetail/:reminderId',
              builder: (context, state) {
                final reminderId = state.pathParameters['reminderId']!;

                return ReminderDetails(
                  id: reminderId,
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: 'viewAllPending',
          path: '/viewAllPending',
          builder: (context, state) {
            return const ViewPendingReminders();
          },
        ),
        GoRoute(
          name: 'viewReminderByLabel',
          path: '/viewReminderByLabel',
          builder: (context, state) {
            return const ViewRemindersByLabel();
          },
        ),
        GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          name: 'signup',
          path: '/signup',
          builder: (context, state) {
            return const SignUp();
          },
        ),
      ],
      // redirect to home page if route is not found
      errorBuilder: (context, state) {
        return const RemindersByDate();
      },
    );
  }
}
