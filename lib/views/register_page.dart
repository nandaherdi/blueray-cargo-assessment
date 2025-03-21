import 'package:blueray_cargo_assessment/view_models/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    var registerProvider = context.read<RegisterViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Pendaftaran"),
            Text("Masukan email anda untuk memulai pendaftaran"),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Masukkan Email"
              ),
            ),
            ElevatedButton(
              onPressed: ()=> registerProvider.checkEmail(_emailController.text),
              child: Text("Daftar Sekarang")
            ),
            Text("Dengan mendaftar anda telah menyetujui"),
            Text("Syarat & Ketentuan dan Kebijakan Privasi"),
          ],
        ),
      ),
    );
  }
}