import 'package:blueray_cargo_assessment/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyEmailWidget extends StatefulWidget {
  final String email;
  const VerifyEmailWidget({super.key, required this.email});

  @override
  State<VerifyEmailWidget> createState() => _VerifyEmailWidgetState();
}

class _VerifyEmailWidgetState extends State<VerifyEmailWidget> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<AuthViewModel>(
        builder: (_, authProvider, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Pendaftaran"),
              Text("Kode verifikasi sudah dikirimkan ke ${widget.email}"),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(hintText: "Masukkan Kode Verifikasi"),
              ),
              ElevatedButton(
                onPressed: () => authProvider.verifyEmail(widget.email, _codeController.text),
                child: Text("Verify Email"),
              ),
              Text("Tidak menerima kode?"),
              TextButton(onPressed: () => authProvider.resendCode(widget.email), child: Text("Kirim Ulang")),
            ],
          );
        },
      ),
    );
  }
}
