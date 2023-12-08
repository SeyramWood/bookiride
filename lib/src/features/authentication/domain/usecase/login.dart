import 'package:bookihub/src/features/authentication/domain/repository/auth_repo.dart';
import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:bookihub/src/shared/utils/usecase.dart';
import 'package:dartz/dartz.dart';

class Login extends UseCase<String,MultiParams<String,String,String>>{
  final AuthRepo repo;

  Login(this.repo);
  @override
  Future<Either<Failure, String>> call(MultiParams<String, String, String> params) async {
   return await repo.login(params.data1,params.data2);
  }
}