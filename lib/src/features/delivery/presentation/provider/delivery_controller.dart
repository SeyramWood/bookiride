import 'dart:io';

import 'package:bookihub/src/features/delivery/domain/entities/delivery_model.dart';
import 'package:bookihub/src/features/delivery/domain/usecase/deliver_package.dart';
import 'package:bookihub/src/features/delivery/domain/usecase/fetch_delivery.dart';
import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:bookihub/src/shared/utils/usecase.dart';
import 'package:dartz/dartz.dart';

import '../../../../shared/errors/failure.dart';

class DeliveryProvider extends ChangeNotifier {
  final FetchDelivery _fetchDelivery;
  final VerifyPackageCode _verifyPackageCode;

  DeliveryProvider(
      {required FetchDelivery fetchDelivery,
      required VerifyPackageCode verifyPackageCode})
      : _fetchDelivery = fetchDelivery,
        _verifyPackageCode = verifyPackageCode;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(loading) {
    _isLoading = loading;
  }

  Future<Either<Failure, List<Delivery>>> fetchDelivery(
      String driverID, String status) async {
    final result = await _fetchDelivery(MultiParams(driverID, status));
    return result.fold(
      (failure) {
        return Left(Failure(failure.message));
      },
      (success) {
        return Right(success);
      },
    );
  }

  Future<Either<Failure, String>> verifyPackageCode(
      String packageId, String packageCode,List<File> idImage) async {
    _isLoading = true;
    notifyListeners();
    final result =
        await _verifyPackageCode(MultiParams(packageId, packageCode,data3: idImage));
    return result.fold(
      (failure) {
        _isLoading = false;
        notifyListeners();
        return Left(Failure(failure.message));
      },
      (success) {
        _isLoading = false;
        notifyListeners();
        return Right(success);
      },
    );
  }
}
