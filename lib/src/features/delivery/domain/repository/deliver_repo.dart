import 'dart:io';

import 'package:bookihub/src/features/delivery/domain/entities/delivery_model.dart';
import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:dartz/dartz.dart';

abstract class DeliveryRepo {
  Future<Either<Failure, List<Delivery>>> fetchDelivery(
      String driverID, String status);
  Future<Either<Failure, String>> verifyPackageCode(
      String packageId, String packageCode,List<File> idImage);
}
