import 'package:bookihub/src/features/authentication/presentation/auth_state.dart';
import 'package:bookihub/src/features/authentication/presentation/dependency/auth_dependencies.dart';
import 'package:bookihub/src/features/authentication/presentation/provider/auth_provider.dart';
import 'package:bookihub/src/features/reports/presentation/dependency/report_dependencies.dart';
import 'package:bookihub/src/features/trip/presentation/dependency/trip_dependency.dart';
import 'package:bookihub/src/shared/utils/interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'src/features/delivery/presentation/dependency/delivery_dependencies.dart';
import 'src/shared/utils/exports.dart';

GetIt locator = GetIt.instance;
const String apiKey = "AIzaSyA_qBSnevO4T8L2pW2qaCl13WOVPX9Gb9U";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  interceptorLocator();
  injectTripDependencies();
  injectDeliveryDependencies();
  injectReportDependencies();
  injectAuthDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => tripProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => deliverProvider,
        ),
        ChangeNotifierProvider(
          create: (context) => reportProvider,
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => authProvider,
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: LightTheme.themeData(),
          home:  const AuthState()),
    );
  }
}


// sk.eyJ1IjoiMDU0NDUxMTU4MSIsImEiOiJjbG9iczNqeXAweWh2MndxcWhsdWN4bjhqIn0.6iHDsqPV-J2QwxR-Uw9-Zg
// pk.eyJ1IjoiMDU0NDUxMTU4MSIsImEiOiJjbHBscDBtMjMwMmcxMmpwNjhwdTV3YmhmIn0.9OfNs-D3HGPVbY-zsCkowA