import 'package:bookihub/src/shared/utils/button_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/constant/colors.dart';
import '../../../../shared/utils/interceptor.dart';
import '../../../../shared/utils/show.snacbar.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../provider/auth_provider.dart';
import 'login_view.dart';

class PasswordUpdateForm extends StatefulWidget {
  const PasswordUpdateForm({super.key});

  @override
  State<PasswordUpdateForm> createState() {
    return _PasswordUpdateFormState();
  }
}

class _PasswordUpdateFormState extends State<PasswordUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Update'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Current Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your old password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
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
                decoration: const InputDecoration(labelText: 'Repeat Password'),
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
              const SizedBox(height: 20),
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
                          (l) => showCustomSnackBar(context, l.message, orange),
                          (r) async {
                        storage.deleteAll();
                        var pref = await SharedPreferences.getInstance();
                        pref.clear();

                        if (mounted) {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginView(),
                              ),
                              );
                          showCustomSnackBar(
                              context,
                              'Password updated successfully.Log in with your new password',
                              green);
                        }
                      });
                    });
                  }
                },
                child: const Text('Update Password'),
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
