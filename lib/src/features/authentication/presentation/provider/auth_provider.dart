import 'package:bookihub/src/features/authentication/domain/usecase/auth_usecase.dart';
import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:bookihub/src/shared/utils/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _user;
  get user => _user;
  getUser(String user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user);
    _user = prefs.getString('user');
    notifyListeners();
  }

  Future<String?> initUser() async {
    final prefs = await SharedPreferences.getInstance();
    _user = prefs.getString('user');
    notifyListeners();
    return _user;
  }

  final Login _login;
  final ResetPassword _resetPassword;
  final UpdatePassword _updatePassword;
  AuthProvider({
    required Login login,
    required ResetPassword resetPassword,
    required UpdatePassword updatePassword,
  })  : _login = login,
        _updatePassword = updatePassword,
        _resetPassword = resetPassword;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isResetting = false;
  bool get isResetting => _isResetting;

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  Future<Either<Failure, String>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final result = await _login(MultiParams(email, password));
    return result.fold(
      (failure) {
        _isLoading = false;
        notifyListeners();
        return Left(Failure(failure.message));
      },
      (success) async {
        _isLoading = false;
        await getUser(success);
        notifyListeners();
        return Right(success);
      },
    );
  }
  Future<Either<Failure, String>> resetPassword(String email, String password, String repeatPassword) async {
    _isResetting = true;
    notifyListeners();
    final result = await _resetPassword(MultiParams(email, password,data3: repeatPassword));
    return result.fold(
      (failure) {
        _isResetting = false;
        notifyListeners();
        return Left(Failure(failure.message=='bad request'?'Check inputs and try again':failure.message));
      },
      (success) async {
        _isResetting = false;
        await getUser(success);
        notifyListeners();
        return Right(success);
      },
    );
  }
  Future<Either<Failure, String>> updatePassword(String currentPasssword, String password, String repeatPassword) async {
    _isUpdating = true;
    notifyListeners();
    final result = await _updatePassword(MultiParams(currentPasssword, password,data3: repeatPassword));
    return result.fold(
      (failure) {
        _isUpdating = false;
        notifyListeners();
        return Left(Failure(failure.message=='bad request'?'Check inputs and try again':failure.message));
      },
      (success) async {
        _isUpdating = false;
        await getUser(success);
        notifyListeners();
        return Right(success);
      },
    );
  }
}
