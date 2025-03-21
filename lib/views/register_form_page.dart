import 'package:blueray_cargo_assessment/models/register_mandatory_model.dart';
import 'package:blueray_cargo_assessment/view_models/register_view_model.dart';
import 'package:blueray_cargo_assessment/widgets/get_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterFormPage extends StatefulWidget {
  final String email;
  const RegisterFormPage({super.key, required this.email});

  @override
  State<RegisterFormPage> createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _idCardNumberController = TextEditingController();
  final TextEditingController _idCardNameController = TextEditingController();
  final TextEditingController _idCardAddressController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _idCardNumberController.dispose();
    _idCardNameController.dispose();
    _idCardAddressController.dispose();
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
            Text("Lengkapi Data"),
            Text("Lengkapi data-data yang dibutuhkan di bawah ini untuk melanjutkan mendaftar"),
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                hintText: "Nama Depan"
              ),
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                hintText: "Nama Belakang"
              ),
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                hintText: "Nomor Telepon"
              ),
            ),
            Consumer<RegisterViewModel>(
              builder: (context, registerProvider, child) {
                return TextFormField(
                  controller: _passwordController,
                  obscureText: registerProvider.isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
                    suffixIcon: IconButton(
                      onPressed: () => registerProvider.setPasswordVisibility = registerProvider.isPasswordVisible ? false : true,
                      icon: Icon(registerProvider.isPasswordVisible ? Icons.visibility : Icons.visibility_off)
                    )
                  ),
                );
              }
            ),
            TextFormField(
              controller: _idCardNumberController,
              decoration: InputDecoration(
                hintText: "Nomor KTP"
              ),
            ),
            TextFormField(
              controller: _idCardNameController,
              decoration: InputDecoration(
                hintText: "Nama KTP"
              ),
            ),
            TextFormField(
              controller: _idCardAddressController,
              decoration: InputDecoration(
                hintText: "Alamat KTP"
              ),
            ),
            GetImageWidget(),
            ElevatedButton(
              onPressed: ()=> registerProvider.saveRegisterData(
                RegisterMandatoryModel(
                  userId: widget.email,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  secondUserId: _phoneNumberController.text,
                  password: _passwordController.text,
                  idCardNumber: _idCardNumberController.text,
                  idCardImage: "",
                  idCardAddress: _idCardAddressController.text,
                  idCardName: _idCardNameController.text
                )
              ),
              child: Text("Simpan")
            ),
            Text("Dengan mendaftar anda telah menyetujui"),
            Text("Syarat & Ketentuan dan Kebijakan Privasi"),
          ],
        ),
      ),
    );
  }
}