import 'dart:io';

import 'package:bookihub/src/features/authentication/data/api/api_service.dart';
import 'package:bookihub/src/features/authentication/domain/repository/auth_repo.dart';
import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../../shared/errors/custom_exception.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiService api;

  AuthRepoImpl({required this.api});
  @override
  Future<Either<Failure, String>> login(String email, String password) async {
    try {
      final result = await api.login(email, password);
      return Right(result);
    } on CustomException catch (failure) {
      return Left(Failure(failure.message));
    } on SocketException catch (se) {
      return Left(Failure(
          se.message == "Failed host lookup: 'devapi.bookihub.com'"
              ? "You are offline. Connect and retry"
              : se.message));
    } catch (e) {
      return Left(Failure('something went wrong'));
    }
  }
}
