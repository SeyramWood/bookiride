import 'package:bookihub/src/features/trip/domain/entities/trip_type.dart';
import 'package:dartz/dartz.dart';
import 'package:bookihub/src/shared/constant/model.dart';

import '../../../../shared/errors/failure.dart';
import '../entities/trip_model.dart';

abstract class TripRepo {
  Future<Either<Failure, List<Trip>>> fetchTrips(
    String iD,
    TripType tripType,
  );
  Future<Either<Failure, String>> updateTripStatus(
    String tripId,
    String status,
  );
  Future<Either<Failure, String>> updateInspectionStatus(
  String tripId,
    InspectionStatus inspectionStatus,
  );
}
