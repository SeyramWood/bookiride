import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/report_model.dart';

abstract class ReportRepo {
  Future<Either<Failure, String>> makeReport(
    String companyId,
    ReportingModel report,
  );
  Future<Either<Failure, List<Report>>> fetchReport(
    String driverId,
  );
}
