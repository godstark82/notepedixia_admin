  import 'package:flutter/material.dart';
import 'package:notepedixia_admin/const/constants.dart';
import 'package:velocity_x/velocity_x.dart';
  

Widget addList(BuildContext context , String heading, Widget widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
            width: context.screenWidth * 0.05,
            child:
                Text(heading, style: const TextStyle(color: Colors.white54))),
        const SizedBox(width: defaultPadding),
        SizedBox(width: context.screenWidth * 0.40, child: widget),
      ],
    );
  }

  