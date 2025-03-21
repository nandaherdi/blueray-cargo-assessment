import 'package:blueray_cargo_assessment/view_models/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    var loginProvider = context.read<LoginViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Login"),
            Text("Anda harus login untuk bisa menggunakan aplikasi ini."),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email"
              ),
            ),
            Consumer<LoginViewModel>(
              builder: (context, loginProvider, child) {
                return TextFormField(
                  controller: _passwordController,
                  obscureText: loginProvider.isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      onPressed: () => loginProvider.setPasswordVisibility = loginProvider.isPasswordVisible ? false : true,
                      icon: Icon(loginProvider.isPasswordVisible ? Icons.visibility : Icons.visibility_off)
                    )
                  ),
                );
              }
            ),
            ElevatedButton(
              onPressed: ()=> loginProvider.checkEmail(_emailController.text),
              child: Text("Masuk")
            ),
            Text("Dengan mendaftar anda telah menyetujui"),
            Text("Syarat & Ketentuan dan Kebijakan Privasi"),
          ],
        ),
      ),
    );
  }
}