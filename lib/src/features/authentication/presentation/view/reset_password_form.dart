import 'dart:developer';

import 'package:bookihub/src/features/authentication/presentation/provider/auth_provider.dart';
import 'package:bookihub/src/shared/constant/colors.dart';
import 'package:bookihub/src/shared/utils/button_extension.dart';
import 'package:bookihub/src/shared/utils/show.snacbar.dart';
import 'package:bookihub/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordResetForm extends StatefulWidget {
  @override
  _PasswordResetFormState createState() => _PasswordResetFormState();
}

class _PasswordResetFormState extends State<PasswordResetForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _repeatPasswordController,
                decoration: InputDecoration(labelText: 'Repeat Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please repeat your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await context
                        .read<AuthProvider>()
                        .resetPassword(
                          _userNameController.text,
                          _passwordController.text,
                          _repeatPasswordController.text,
                        )
                        .then((value) {
                      value.fold(
                          (l) => showCustomSnackBar(
                              context, l.message, orange),
                          (r) {
                        showCustomSnackBar(
                            context, 'Password reset successfully', green);
                        clearField();
                        Navigator.of(context).pop();
                      });
                    });
                  }
                },
                child: Text('Reset Password'),
              ).loading(context.watch<AuthProvider>().isResetting),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  void clearField() {
    _repeatPasswordController.clear();
    _passwordController.clear();
    _userNameController.clear();
  }
}
