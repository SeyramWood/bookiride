import 'package:bookihub/src/shared/utils/exports.dart';
import 'package:bookihub/src/shared/widgets/custom_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

extension ButtonExtension on CustomButton {
  loading(bool isLoading, {Color color = blue}) {
    return isLoading
        ? SizedBox(
            height: 30,
            // dimension: 20,
            child: SpinKitWave(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven ? orange : color,
                  ),
                );
              },
            ),
          )
        : this;
  }
}
