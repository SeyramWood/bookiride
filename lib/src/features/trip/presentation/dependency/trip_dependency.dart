import 'package:bookihub/main.dart';
import 'package:bookihub/src/features/trip/data/api/api_service.dart';
import 'package:bookihub/src/features/trip/data/repository/trip_repo_impl.dart';
import 'package:bookihub/src/features/trip/domain/usecase/fetch_trip.dart';
import 'package:bookihub/src/features/trip/domain/usecase/update_inspection_status.dart';
import 'package:bookihub/src/features/trip/domain/usecase/update_trip_status.dart';
import 'package:bookihub/src/features/trip/presentation/provider/trip_provider.dart';

injectTripDependencies() {
  locator.registerLazySingleton<TripApiService>(() => TripApiService());
  locator.registerLazySingleton<TripRepoImpl>(
      () => TripRepoImpl(locator<TripApiService>()));
  locator.registerLazySingleton<FetchTrips>(
      () => FetchTrips(locator<TripRepoImpl>()));
       locator.registerLazySingleton<UpdateTripStatus>(
      () => UpdateTripStatus(locator<TripRepoImpl>()));
      locator.registerLazySingleton<UpdateInspectionStatus>(
      () => UpdateInspectionStatus(locator<TripRepoImpl>()));
        locator.registerLazySingleton<TripProvider>(()=>tripProvider);

}
final tripProvider = TripProvider(fetchTrips: locator<FetchTrips>(),updateTripStatus: locator<UpdateTripStatus>(),inspectionStatus:locator<UpdateInspectionStatus>());