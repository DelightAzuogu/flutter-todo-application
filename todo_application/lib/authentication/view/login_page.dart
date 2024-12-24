import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:todo_application/authentication/providers/authentication_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  void togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authenticationController = ref.read(authenticationControllerProvider.notifier);
    final formGroup = authenticationController.formGroup;

    formGroup.control('name').value = 'name field';

    void clearFieldText(String formControlName) {
      formGroup.control(formControlName).value = '';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: formGroup,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(30),
              ReactiveTextField(
                formControlName: 'email',
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      clearFieldText('email');
                    },
                  ),
                ),
                validationMessages: {
                  ValidationMessage.required: (error) => 'The email must not be empty',
                  ValidationMessage.email: (error) => 'The email value must be a valid email',
                },
              ),
              const Gap(30),
              ReactiveTextField(
                formControlName: 'password',
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: togglePasswordVisibility,
                  ),
                ),
                validationMessages: {
                  ValidationMessage.required: (error) => 'The password must not be empty',
                  ValidationMessage.minLength: (error) => 'The password must be at least 8 characters long',
                },
              ),
              const Spacer(),
              ReactiveFormConsumer(
                builder: (context, form, child) {
                  return ElevatedButton(
                    onPressed: form.valid
                        ? () async {
                            await authenticationController.login();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Login'),
                  );
                },
              ),
              TextButton(
                onPressed: () {
                  clearFieldText('name');
                  context.goNamed('signup');
                },
                child: const Center(
                  child: Text('Don\'t have an account? Sign up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
