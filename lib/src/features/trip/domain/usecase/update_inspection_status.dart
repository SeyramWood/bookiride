import 'package:bookihub/src/shared/constant/model.dart';

import 'package:bookihub/src/features/trip/domain/repository/trip_repo.dart';
import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:bookihub/src/shared/utils/usecase.dart';
import 'package:dartz/dartz.dart';

class UpdateInspectionStatus
    extends UseCase<String, MultiParams<String, InspectionStatus, String>> {
      final TripRepo repo;

  UpdateInspectionStatus(this.repo);
  @override
  Future<Either<Failure, String>> call(
      MultiParams<String, InspectionStatus, String> params) async {
    return await repo.updateInspectionStatus(params.data1,params.data2);
  }
}
