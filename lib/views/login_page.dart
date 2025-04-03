import 'package:blueray_cargo_assessment/models/requests/login_request_model.dart';
import 'package:blueray_cargo_assessment/view_models/base_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/auth_view_model.dart';
import 'package:blueray_cargo_assessment/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Consumer<AuthViewModel>(
            builder: (_, authProvider, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Login"),
                  Text("Anda harus login untuk bisa menggunakan aplikasi ini."),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                    // onChanged: (_) => authProvider.checkLoginFormValidity(_formKey),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return authProvider.validateEmail(value);
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: authProvider.isLoginPasswordVisible,
                    keyboardType: TextInputType.visiblePassword,
                    // onChanged: (_) => authProvider.checkLoginFormValidity(_formKey),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return authProvider.validatePassword(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: IconButton(
                        onPressed:
                            () =>
                                authProvider.isLoginPasswordVisible =
                                    authProvider.isLoginPasswordVisible ? false : true,
                        icon: Icon(authProvider.isLoginPasswordVisible ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                  ),
                  Consumer<BaseViewModel>(
                    builder: (_, baseProvider, _) {
                      return ElevatedButton(
                        onPressed:
                            () => baseProvider.navigateForegroundProcess(
                              () => authProvider.doLogin(
                                LoginRequestModel(userId: _emailController.text, password: _passwordController.text),
                                _formKey,
                              ),
                              HomePage(),
                            ),
                        // onPressed: ()=> loginProvider.checkEmail(_emailController.text),
                        child: Text("Masuk"),
                      );
                    },
                  ),
                  Text("Dengan mendaftar anda telah menyetujui"),
                  Text("Syarat & Ketentuan dan Kebijakan Privasi"),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
