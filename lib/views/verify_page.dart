import 'package:blueray_cargo_assessment/view_models/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyPage extends StatefulWidget {
  final String email;
  const VerifyPage({super.key, required this.email});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
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
            Text("Kode verifikasi sudah dikirimkan ke ${widget.email}"),
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(
                hintText: "Masukkan Kode Verifikasi"
              ),
            ),
            ElevatedButton(
              onPressed: () => registerProvider.verifyEmail(widget.email, _codeController.text),
              child: Text("Verify Email")
            ),
            Text("Tidak menerima kode?"),
            TextButton(
              onPressed: () => registerProvider.resendCode(widget.email),
              child: Text("Kirim Ulang")
            )
          ],
        ),
      ),
    );
  }
}