import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failure,String>> login(String email, String password);
}
