import 'package:bookihub/src/features/authentication/presentation/provider/auth_provider.dart';
import 'package:bookihub/src/shared/utils/button_extension.dart';
import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:bookihub/src/shared/utils/show.snacbar.dart';
import 'package:bookihub/src/shared/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? validateEmail(String value) {
    // Email validation regex
    const emailRegex = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    final regExp = RegExp(emailRegex);

    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepBlue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset(CustomeImages.logo),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      validator: (value) => validateEmail(value!),
                      decoration: InputDecoration(
                        fillColor: white,
                        filled: true,
                        hintText: "example@email.com",
                        labelText: "Username",
                        errorStyle: const TextStyle(fontSize: 15),
                        labelStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  backgroundColor: white,
                                ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid password';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: white,
                        filled: true,
                        errorStyle: const TextStyle(fontSize: 15),
                        labelText: "Password",
                        labelStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  backgroundColor: white,
                                ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    CustomButton(
                      bgColor: orange,
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await context
                              .read<AuthProvider>()
                              .login(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              )
                              .then(
                            (value) async {
                              value.fold(
                                (failure) => showCustomSnackBar(
                                    context, failure.message, orange),
                                (success) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const MainPage();
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: const Text("Login"),
                    ).loading(context.watch<AuthProvider>().isLoading,
                        color: white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
