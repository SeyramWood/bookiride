import 'package:bookihub/src/features/trip/domain/entities/trip_model.dart';
import 'package:bookihub/src/features/trip/domain/entities/trip_type.dart';
import 'package:bookihub/src/features/trip/domain/repository/trip_repo.dart';
import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:bookihub/src/shared/utils/usecase.dart';
import 'package:dartz/dartz.dart';

class FetchTrips extends UseCase<List<Trip>, MultiParams<String, TripType, bool>> {
  final TripRepo repo;

  FetchTrips(this.repo);

  @override
  Future<Either<Failure, List<Trip>>> call(
      MultiParams<String, TripType, bool> params) async {
    return await repo.fetchTrips(params.data1, params.data2);
  }
}
