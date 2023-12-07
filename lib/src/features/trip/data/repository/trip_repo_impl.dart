import 'dart:developer';
import 'dart:io';

import 'package:bookihub/src/features/trip/data/api/api_service.dart';
import 'package:bookihub/src/features/trip/domain/entities/trip_model.dart';
import 'package:bookihub/src/features/trip/domain/entities/trip_type.dart';
import 'package:bookihub/src/features/trip/domain/repository/trip_repo.dart';
import 'package:bookihub/src/shared/errors/custom_exception.dart';
import 'package:dartz/dartz.dart';
import 'package:bookihub/src/shared/constant/model.dart';

import '../../../../shared/errors/failure.dart';

class TripRepoImpl implements TripRepo {
  final TripApiService api;

  TripRepoImpl(this.api);

  @override
  Future<Either<Failure, List<Trip>>> fetchTrips(
    String iD,
    TripType tripType,
  ) async {
    try {
      final result = await api.fetchTrips(iD, tripType);
      return Right(result);
    } on CustomException catch (failure) {
      return Left(Failure(failure.message));
    } on SocketException catch (se) {
      return Left(Failure(
          se.message == "Failed host lookup: 'devapi.bookihub.com'"
              ? "You are offline. Connect and retry"
              : se.message));
    } catch (e) {
      log(' trip: $e');
      return Left(Failure('something went wrong'));
    }
  }

  @override
  Future<Either<Failure, String>> updateTripStatus(
      String tripId, String status) async {
    try {
      await api.updateTripStatus(tripId, status);
      return const Right('started');
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
  Future<Either<Failure, String>> updateInspectionStatus(
      String tripId, InspectionStatus inspectionStatus) async {
    try {
      await api.updateInspectionStatus(tripId, inspectionStatus);
      return const Right('Inpections submitted successfully');
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
