import 'package:bookihub/src/features/delivery/presentation/provider/change.content.dart';
import 'package:bookihub/src/features/delivery/presentation/views/delivered_view.dart';
import 'package:bookihub/src/shared/constant/dimensions.dart';
import 'package:bookihub/src/shared/utils/exports.dart';

import 'outgoing_delivery_view.dart';

class DeliveryView extends StatelessWidget {
  const DeliveryView({super.key});

  @override
  Widget build(BuildContext context) {
    final OutgoingOrDelivered state = OutgoingOrDelivered();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: hPadding)
              .copyWith(top: 20),
          child: ValueListenableBuilder(
            valueListenable: state,
            builder: (ctx, deliveryState, child) => Column(
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => state.isClicked(true),
                          child: Container(
                            height: 35,
                            width: MediaQuery.sizeOf(context).width / 2,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5)),
                              color: deliveryState ? blue : white,
                            ),
                            child: Center(
                              child: Text(
                                'Outgoing',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 12,
                                      color: deliveryState ? white : black,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => state.isClicked(false),
                          child: Container(
                            height: 35,
                            width: MediaQuery.sizeOf(context).width / 2,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5)),
                              color: deliveryState ? white : blue,
                            ),
                            child: Center(
                              child: Text(
                                'Delivered',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 12,
                                      color: deliveryState ? black : white,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                vSpace,
                Expanded(
                    child: deliveryState
                        ? const OutGoingView()
                        : const DeliveredView())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
