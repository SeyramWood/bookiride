import 'package:bookihub/main.dart';
import 'package:bookihub/src/features/delivery/data/api/delivery_api.dart';
import 'package:bookihub/src/features/delivery/data/repository/delivery_repo_impl.dart';
import 'package:bookihub/src/features/delivery/domain/usecase/deliver_package.dart';
import 'package:bookihub/src/features/delivery/domain/usecase/fetch_delivery.dart';

import '../provider/delivery_controller.dart';

injectDeliveryDependencies() {
  locator.registerLazySingleton<DeliveryApiService>(() => DeliveryApiService());
  locator.registerLazySingleton<DeliverRepoImpl>(
      () => DeliverRepoImpl(locator<DeliveryApiService>()));
  locator.registerLazySingleton<FetchDelivery>(
      () => FetchDelivery(locator<DeliverRepoImpl>()));
  locator.registerLazySingleton<VerifyPackageCode>(
      () => VerifyPackageCode(locator<DeliverRepoImpl>()));
}

final deliverProvider = DeliveryProvider(
    fetchDelivery: locator<FetchDelivery>(),
    verifyPackageCode: locator<VerifyPackageCode>());
