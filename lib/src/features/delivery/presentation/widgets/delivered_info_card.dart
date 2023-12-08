import 'package:bookihub/src/features/delivery/domain/entities/delivery_model.dart';
import 'package:bookihub/src/shared/constant/dimensions.dart';
import 'package:bookihub/src/shared/utils/exports.dart';

class DeliveredInfoCard extends StatelessWidget {
  final Delivery package;

  const DeliveredInfoCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListTile(
          dense: true,
          leading: const Icon(
            Icons.location_on,
            color: Colors.red,
          ),
          title: Text(package.recipientLocation),
        ),
        ListTile(
          dense: true,
          leading: const Icon(
            Icons.person,
            color: grey,
          ),
          title: Text(package.recipientName),
        ),
        ListTile(
          dense: true,
          leading: const Icon(
            Icons.phone,
            color: blue,
          ),
          title: Text(package.recipientPhone),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Review'),
          ),
        )
      ]),
    );
  }
}
