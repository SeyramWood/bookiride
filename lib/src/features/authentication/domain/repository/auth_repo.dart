import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failure,String>> login(String email, String password);
  Future<Either<Failure,String>> resetPassword(String oldPassword, String password,String repeatPassword);
  Future<Either<Failure,String>> updatePassword(String email, String password,String repeatPassword);
}
