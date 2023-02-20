import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  final bool isRegistering;
  const RegisterPage({super.key, required this.isRegistering});

  //*MaterialPage Route
  static Route<void> route({bool isRegistering = false}) {
    return MaterialPageRoute(
        builder: (context) => RegisterPage(
              isRegistering: isRegistering,
            ));
  }

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  //*Funcion de Registro
  Future<void> _signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    //*Obtener los valores del TextField
    final email = emailController.text;
    final password = passwordController.text;
    final username = usernameController.text;

    try {
      await supabase.auth.signUp(
        email: email,
        password: password,
        data: {"username": username},
      );
      Navigator.of(context)
          .pushAndRemoveUntil(ChatPage.route(), (route) => false);
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: formPadding,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                label: Text("Email"),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Required";
                }

                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            formSpace,
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                label: Text("Password"),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Required";
                }
                if (value.length < 6) {
                  return "Minimo 6 caracteres";
                }

                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            formSpace,
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                label: Text("Username"),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Required";
                }
                final isValid = RegExp(r'^[A-Za-z0-9_]{3,24}$').hasMatch(value);
                if (!isValid) {
                  return "3-24 caracteres alfanumericos o guiones bajos";
                }

                return null;
              },
            ),
            formSpace,
            ElevatedButton(
              onPressed: isLoading ? null : _signUp,
              child: const Text("Register"),
            ),
            formSpace,
            TextButton(
              onPressed: () {
                Navigator.of(context).push(LoginPage.route());
              },
              child: const Text("Ya tengo una cuenta"),
            ),
          ],
        ),
      ),
    );
  }
}
