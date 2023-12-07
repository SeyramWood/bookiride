import 'dart:developer';
import 'dart:io';

import 'package:bookihub/src/features/reports/data/api/api_service.dart';
import 'package:bookihub/src/features/reports/domain/entities/report_model.dart';
import 'package:bookihub/src/features/reports/domain/repository/report_repository.dart';
import 'package:bookihub/src/shared/errors/custom_exception.dart';
import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:dartz/dartz.dart';

class ReportRepoImpl implements ReportRepo {
  final ReportApiService api;

  ReportRepoImpl(this.api);
  @override
  Future<Either<Failure, String>> makeReport(
      String companyId, ReportingModel report) async {
    try {
      await api.makeReport(companyId, report);
      return const Right('Report sent');
    } on CustomException catch (failure) {
      return Left(Failure(failure.message));
    } on SocketException catch (se) {
      return Left(Failure(
          se.message == "Failed host lookup: 'devapi.bookihub.com'"
              ? "You are offline. Connect and retry"
              : se.message));
    } catch (e) {
      log('$e');
      return Left(Failure('something went wrong'));
    }
  }

  @override
  Future<Either<Failure, List<Report>>> fetchReport(String driverId) async {
    try {
      final result = await api.fetchReports(driverId);
      return Right(result);
    } on CustomException catch (failure) {
      return Left(Failure(failure.message));
    } on SocketException catch (se) {
      return Left(Failure(
          se.message == "Failed host lookup: 'devapi.bookihub.com'"
              ? "You are offline. Connect and retry"
              : se.message));
    } catch (e) {
      log('$e');
      return Left(Failure('something went wrong'));
    }
  }
}
