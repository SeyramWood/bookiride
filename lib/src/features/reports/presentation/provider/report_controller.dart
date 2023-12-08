import 'package:bookihub/src/features/reports/domain/usecase/fetch_reports.dart';
import 'package:bookihub/src/features/reports/domain/usecase/make_report.dart';
import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:bookihub/src/shared/utils/usecase.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/report_model.dart';

class ReportProvider extends ChangeNotifier {
  final MakeReport _makeReport;
  final FetchReport _fetchReport;

  ReportProvider(
      {required MakeReport makeReport, required FetchReport fetchReport})
      : _makeReport = makeReport,
        _fetchReport = fetchReport;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  set isLoading(loading) {
    _isLoading = loading;
  }

  Future<Either<Failure, String>> makeReport(
      String companyId, ReportingModel report) async {
    _isLoading = true;
    notifyListeners();
    final result = await _makeReport(MultiParams(companyId, report));
    return result.fold((failure) {
      _isLoading = false;
      notifyListeners();
      return Left(Failure(failure.message));
    }, (success) {
      _isLoading = false;
      notifyListeners();
      return Right(success);
    });
  }

  Future<Either<Failure, List<Report>>> fetchReport(String driverId) async {
    final result = await _fetchReport(Param(driverId));
    return result.fold((failure) {
      return Left(Failure(failure.message));
    }, (success) {
      return Right(success);
    });
  }
}
