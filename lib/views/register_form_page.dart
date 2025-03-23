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
  final _formKey = GlobalKey<FormState>();
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
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Lengkapi Data"),
                  Text("Lengkapi data-data yang dibutuhkan di bawah ini untuk melanjutkan mendaftar"),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 15,
                    children: [
                      TextFormField(
                        controller: _firstNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Nama Depan",
                          border: OutlineInputBorder(),
                        ),
                        //onChanged: (value) => registerProvider.checkFormValidity(_formKey),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => registerProvider.validateName(value),
                      ),
                      TextFormField(
                        controller: _lastNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Nama Belakang",
                          border: OutlineInputBorder(),
                        ),
                        //onChanged: (value) => registerProvider.checkFormValidity(_formKey),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => registerProvider.validateName(value),
                      ),
                      TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Nomor Telepon",
                          border: OutlineInputBorder()
                        ),
                        //onChanged: (value) => registerProvider.checkFormValidity(_formKey),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => registerProvider.validatePhoneNumber(value),
                      ),
                      Consumer<RegisterViewModel>(
                        builder: (context, registerProvider, child) {
                          return TextFormField(
                            controller: _passwordController,
                            obscureText: registerProvider.isPasswordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              hintText: "Password",
                              border: OutlineInputBorder(),
                              errorMaxLines: 2,
                              suffixIcon: IconButton(
                                onPressed: () => registerProvider.isPasswordVisible = registerProvider.isPasswordVisible ? false : true,
                                icon: Icon(registerProvider.isPasswordVisible ? Icons.visibility : Icons.visibility_off)
                              )
                            ),
                            //onChanged: (value) => registerProvider.checkFormValidity(_formKey),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => registerProvider.validatePassword(value),
                          );
                        }
                      ),
                      TextFormField(
                        controller: _idCardNumberController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Nomor KTP",
                          border: OutlineInputBorder()
                        ),
                        //onChanged: (value) => registerProvider.checkFormValidity(_formKey),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => registerProvider.validateIdCardNumber(value),
                      ),
                      TextFormField(
                        controller: _idCardNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Nama KTP",
                          border: OutlineInputBorder()
                        ),
                        //onChanged: (value) => registerProvider.checkFormValidity(_formKey),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => registerProvider.validateIdCardName(value),
                      ),
                      TextFormField(
                        minLines: 3,
                        maxLines: 5,
                        maxLength: 200,
                        controller: _idCardAddressController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Alamat KTP",
                          border: OutlineInputBorder()
                        ),
                        //onChanged: (value) => registerProvider.checkFormValidity(_formKey),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => registerProvider.validateIdCardAddress(value),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Upload Foto KTP")
                      ),
                      GetImageWidget(),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: ()=> registerProvider.checkFormValidity(
                      _formKey,
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
          ),
        ),
      ),
    );
  }
}