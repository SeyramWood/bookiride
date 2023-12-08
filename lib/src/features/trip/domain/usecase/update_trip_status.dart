import 'package:bookihub/src/features/trip/domain/repository/trip_repo.dart';
import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:bookihub/src/shared/utils/usecase.dart';
import 'package:dartz/dartz.dart';

class UpdateTripStatus
    extends UseCase<String, MultiParams<String, String, String>> {
      final TripRepo repo;

  UpdateTripStatus(this.repo);
  @override
  Future<Either<Failure, String>> call(
      MultiParams<String, String, String> params) async {
    return await repo.updateTripStatus(params.data1,params.data2);
  }
}
