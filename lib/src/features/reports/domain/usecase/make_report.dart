import 'package:bookihub/src/features/reports/domain/entities/report_model.dart';
import 'package:bookihub/src/features/reports/domain/repository/report_repository.dart';
import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:bookihub/src/shared/utils/usecase.dart';
import 'package:dartz/dartz.dart';

class MakeReport extends UseCase<String,MultiParams<String, ReportingModel,String>>{
  final ReportRepo repo;

  MakeReport(this.repo);
  @override
  Future<Either<Failure, String>> call(MultiParams<String, ReportingModel, String> params) async {
   return await repo.makeReport(params.data1,params.data2);
  }
}