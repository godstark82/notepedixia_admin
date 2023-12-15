import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.75,
      width: context.screenWidth,
      child: const Center(
        child: Text('No Data Found'),
      ),
    );
  }
}
