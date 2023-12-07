import 'package:bookihub/src/features/reports/domain/entities/report_model.dart';
import 'package:bookihub/src/features/reports/domain/repository/report_repository.dart';
import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:bookihub/src/shared/utils/usecase.dart';
import 'package:dartz/dartz.dart';

class FetchReport extends UseCase<List<Report>,Param<String>>{
  final ReportRepo repo;

  FetchReport(this.repo);
  @override
  Future<Either<Failure, List<Report>>> call(Param<String> params) async {
   return await repo.fetchReport(params.data);
  }
}