import 'package:bookihub/main.dart';
import 'package:bookihub/src/features/authentication/data/api/api_service.dart';
import 'package:bookihub/src/features/authentication/data/repository/auth_repo_impl.dart';
import 'package:bookihub/src/features/authentication/domain/usecase/login.dart';
import 'package:bookihub/src/features/authentication/presentation/provider/auth_provider.dart';

injectAuthDependencies(){
  locator.registerLazySingleton<ApiService>(()=>ApiService());
  locator.registerLazySingleton<AuthRepoImpl>(()=>AuthRepoImpl(api: locator<ApiService>()));
  locator.registerLazySingleton<Login>(()=>Login(locator<AuthRepoImpl>()));
}

final authProvider = AuthProvider(login: locator<Login>());