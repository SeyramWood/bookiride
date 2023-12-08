import 'package:bookihub/main.dart';
import 'package:bookihub/src/features/reports/data/api/api_service.dart';
import 'package:bookihub/src/features/reports/data/repository/report_repo_impl.dart';
import 'package:bookihub/src/features/reports/domain/usecase/fetch_reports.dart';
import 'package:bookihub/src/features/reports/domain/usecase/make_report.dart';
import 'package:bookihub/src/features/reports/presentation/provider/report_controller.dart';

injectReportDependencies() {
  locator.registerLazySingleton<ReportApiService>(() => ReportApiService());
  locator.registerLazySingleton<ReportRepoImpl>(
      () => ReportRepoImpl(locator<ReportApiService>()));
  locator.registerLazySingleton<MakeReport>(
      () => MakeReport(locator<ReportRepoImpl>()));
      locator.registerLazySingleton<FetchReport>(
      () => FetchReport(locator<ReportRepoImpl>()));
}

final reportProvider = ReportProvider(makeReport: locator<MakeReport>(),fetchReport: locator<FetchReport>());  
