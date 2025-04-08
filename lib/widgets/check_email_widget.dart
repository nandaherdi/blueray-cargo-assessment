import 'package:blueray_cargo_assessment/view_models/auth_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckEmailWidget extends StatefulWidget {
  const CheckEmailWidget({super.key});

  @override
  State<CheckEmailWidget> createState() => _CheckEmailWidgetState();
}

class _CheckEmailWidgetState extends State<CheckEmailWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Consumer<AuthViewModel>(
          builder: (_, authProvider, _) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 15,
              children: [
                Text("Pendaftaran"),
                Text("Masukan email anda untuk memulai pendaftaran"),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: "Masukkan Email"),
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => context.read<BaseViewModel>().validateEmail(value),
                  onChanged: (value) => authProvider.checkEmailValidity(_formKey),
                ),
                ElevatedButton(
                  onPressed: authProvider.isEmailValid ? () => authProvider.checkEmail(_emailController.text) : null,
                  child: Text("Cek Email"),
                ),
                // Text("Dengan mendaftar anda telah menyetujui"),
                // Text("Syarat & Ketentuan dan Kebijakan Privasi"),
              ],
            );
          },
        ),
      ),
    );
  }
}