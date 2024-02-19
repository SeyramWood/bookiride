import 'package:bookihub/main.dart';
import 'package:bookihub/src/features/authentication/data/api/api_service.dart';
import 'package:bookihub/src/features/authentication/data/repository/auth_repo_impl.dart';
import 'package:bookihub/src/features/authentication/domain/usecase/auth_usecase.dart';
import 'package:bookihub/src/features/authentication/presentation/provider/auth_provider.dart';

injectAuthDependencies() {
  locator.registerLazySingleton<ApiService>(() => ApiService());
  locator.registerLazySingleton<AuthRepoImpl>(
      () => AuthRepoImpl(api: locator<ApiService>()));
  locator.registerLazySingleton<Login>(() => Login(locator<AuthRepoImpl>()));
  locator.registerLazySingleton<ResetPassword>(
      () => ResetPassword(locator<AuthRepoImpl>()));
  locator.registerLazySingleton<UpdatePassword>(
      () => UpdatePassword(locator<AuthRepoImpl>()));
}

final authProvider = AuthProvider(
  login: locator<Login>(),
  resetPassword: locator<ResetPassword>(),
  updatePassword: locator<UpdatePassword>(),
);
