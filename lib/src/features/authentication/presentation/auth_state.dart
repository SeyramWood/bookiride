import 'package:bookihub/src/features/authentication/presentation/provider/auth_provider.dart';
import 'package:bookihub/src/features/authentication/presentation/view/login_view.dart';
import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:provider/provider.dart';

class AuthState extends StatefulWidget {
  const AuthState({super.key});

  @override
  State<AuthState> createState() => _AuthStateState();
}

class _AuthStateState extends State<AuthState> {
  String? _user;
  @override
  void initState() {
    super.initState();
    isThereAUser();
  }

  isThereAUser() async {
    await context.read<AuthProvider>().initUser().then((user) {
      _user = user;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null || _user!.isEmpty) {
      return const LoginView();
    } else {
      return const MainPage();
    }
  }
}
