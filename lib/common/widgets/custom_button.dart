import 'package:flutter/material.dart';

class CustomButton {
  // custom button with fix design, example fix colorm height size and font size
  static Widget normalCustomButton({void Function()? onTap, required String text}) {
   return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.blue,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          height: 45,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // static allCustomButton({
  //   void Function()? onTap,
  //   required String text,
  //   double? fontSize,
  //   Color? color,
  //   FontWeight? fontWeight,
  //   double? height,
  // }) {
  //   Material(
  //     borderRadius: BorderRadius.circular(12),
  //     color: Colors.blue,
  //     child: InkWell(
  //       borderRadius: BorderRadius.circular(12),
  //       onTap: onTap,
  //       child: SizedBox(
  //         width: double.infinity,
  //         height: height,
  //         child: Center(
  //           child: Text(
  //             text,
  //             style: TextStyle(
  //               fontWeight: fontWeight,
  //               color: color,
  //               fontSize: fontSize,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
