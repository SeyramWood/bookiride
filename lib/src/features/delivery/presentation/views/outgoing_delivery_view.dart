import 'dart:async';

import 'package:bookihub/src/features/authentication/presentation/provider/auth_provider.dart';
import 'package:bookihub/src/features/delivery/domain/entities/delivery_model.dart';
import 'package:bookihub/src/features/delivery/presentation/provider/delivery_controller.dart';
import 'package:bookihub/src/features/delivery/presentation/views/outgoing_delivery_details.dart';
import 'package:bookihub/src/shared/constant/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../main.dart';
import '../../../../shared/constant/colors.dart';
import '../../../../shared/utils/show.snacbar.dart';
import '../widgets/info_card.dart';

class OutGoingView extends StatefulWidget {
  const OutGoingView({super.key});

  @override
  State<OutGoingView> createState() => _OutGoingViewState();
}

class _OutGoingViewState extends State<OutGoingView> {
 late List<Delivery>? delivery;
  final StreamController<List<Delivery>> _streamController = StreamController();
// ignore: unused_field
  late Timer _timer;
  fetchDeliveries() async {
    if (mounted) {
      final id = context.read<AuthProvider>().user;
           
      final result =
          await context.read<DeliveryProvider>().fetchDelivery(id, 'outgoing');

      result.fold(
          (failure) => showCustomSnackBar(context, failure.message, orange),
          (success) {
        _streamController.sink.add(success);
        if (mounted) {
          setState(() {
            delivery = success;
          });
        }
      });
    }
  }
  // fetchDeliveries() async {
  //   final result = await context
  //       .read<DeliveryProvider>()
  //       .fetchDelivery('12884901890', 'outgoing');
  //   result
  //       .fold((failure) => showCustomSnackBar(context, failure.message, orange),
  //           (success) {
  //     setState(() {
  //       delivery = Future.value(success);
  //     });
  //   });
  // }

  @override
  void initState() {
    fetchDeliveries();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      fetchDeliveries();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Delivery>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            var package = snapshot.data!;

            return ListView.separated(
              itemCount: package.length,
              separatorBuilder: (context, index) => vSpace,
              itemBuilder: (context, index) {
                if (!locator.isRegistered<InfoCard>()) {
                  locator.registerLazySingleton<InfoCard>(() => InfoCard(
                        package: package[index],
                      ));
                }
                return InfoCard(
                  package: package[index],
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>  PackageDetailsView(package: package[index],),
                  )),
                );
              },
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('You have no package available.'));
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
