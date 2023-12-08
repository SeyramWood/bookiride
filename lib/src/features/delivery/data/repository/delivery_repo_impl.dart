import 'dart:developer';
import 'dart:io';

import 'package:bookihub/src/features/delivery/data/api/delivery_api.dart';
import 'package:bookihub/src/features/delivery/domain/entities/delivery_model.dart';
import 'package:bookihub/src/features/delivery/domain/repository/deliver_repo.dart';
import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../../shared/errors/custom_exception.dart';

class DeliverRepoImpl implements DeliveryRepo {
  final DeliveryApiService api;

  DeliverRepoImpl(this.api);
  @override
  Future<Either<Failure, List<Delivery>>> fetchDelivery(
      String driverID, String status) async {
    try {
      final result = await api.fetchDelivery(driverID, status);
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

  @override
  Future<Either<Failure, String>> verifyPackageCode(
      String packageId, String packageCode, List<File> idImage) async {
    log('$packageId, $packageCode,$idImage');

    try {
      log('$packageId, $packageCode,$idImage');

      await api.verifyPackageCode(packageId, packageCode, idImage);
      return const Right('package code verification successsful');
    } on CustomException catch (failure) {
      return Left(Failure(failure.message));
    } on SocketException catch (se) {
      return Left(Failure(
          se.message == "Failed host lookup: 'devapi.bookihub.com'"
              ? "You are offline. Connect and retry"
              : se.message));
    } catch (e) {
      log('delivery: $e');
      return Left(Failure('something went wrong'));
    }
  }
}
