import 'package:flutter/material.dart';

class TripInspectRow extends StatelessWidget {
  const TripInspectRow({
    super.key,
    required this.onChanged,
    required this.value,
    required this.label,
  });
  final bool value;
  final void Function()? onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: GestureDetector(
        onTap: onChanged,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            value
                ? Image.asset('assets/icons/toggle.png')
                : Image.asset('assets/icons/inactive_toggle.png'),
      
            // Transform.scale(
            //   scale: 0.85, // Adjust the scale factor as needed
            //   child: Switch(
            //     onChanged: onChanged,
            //     trackOutlineColor: MaterialStateProperty.all(white),
            //     thumbColor: MaterialStateProperty.all(white),
            //     activeColor: blue,
            //     inactiveTrackColor: switchColor,
            //     inactiveThumbImage:
            //         AssetImage('assets/icons/inactive_toggle.png'),
            //     // thumbIcon: MaterialStateProperty.all(),
            //     value: value,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
