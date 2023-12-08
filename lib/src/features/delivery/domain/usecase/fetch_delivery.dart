import 'package:bookihub/src/features/delivery/domain/entities/delivery_model.dart';
import 'package:bookihub/src/features/delivery/domain/repository/deliver_repo.dart';
import 'package:bookihub/src/shared/errors/failure.dart';
import 'package:bookihub/src/shared/utils/usecase.dart';
import 'package:dartz/dartz.dart';

class FetchDelivery
    extends UseCase<List<Delivery>, MultiParams<String, String, String>> {
  final DeliveryRepo repo;

  FetchDelivery(this.repo);
  @override
  Future<Either<Failure, List<Delivery>>> call(
      MultiParams<String, String, String> params) async {
    return await repo.fetchDelivery(params.data1, params.data2);
  }
}
