import 'package:bookihub/src/features/delivery/domain/entities/delivery_model.dart';
import 'package:bookihub/src/shared/utils/exports.dart';

import '../../../../shared/constant/dimensions.dart';

class InfoCard extends StatelessWidget {
  final void Function()? onTap;
  final Delivery package;
  const InfoCard({super.key, this.onTap, required this.package});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Material(
        borderRadius: borderRadius,
        child: Column(children: [
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
        ]),
      ),
    );
  }
}
