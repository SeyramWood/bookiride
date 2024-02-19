import 'package:bookihub/src/shared/utils/button_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/constant/colors.dart';
import '../../../../shared/utils/show.snacbar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../provider/auth_provider.dart';

class PasswordUpdateForm extends StatefulWidget {
  @override
  _PasswordUpdateFormState createState() => _PasswordUpdateFormState();
}

class _PasswordUpdateFormState extends State<PasswordUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Update'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(labelText: 'Current Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your old password';
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
                        .updatePassword(
                      _currentPasswordController.text,
                      _passwordController.text,
                      _repeatPasswordController.text,
                    )
                        .then((value) {
                      value.fold(
                              (l) => showCustomSnackBar(
                              context, l.message, orange),
                              (r) {
                            showCustomSnackBar(
                                context, 'Password updated successfully', green);
                            Navigator.of(context).pop();
                          });
                    });
                  }
                },
                child: Text('Update Password'),
              ).loading(context.watch<AuthProvider>().isUpdating),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }
}

