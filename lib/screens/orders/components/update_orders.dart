// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:notepedixia_admin/const/constants.dart';
import 'package:notepedixia_admin/models/order_model.dart';
import 'package:notepedixia_admin/const/responsive.dart';
import 'package:velocity_x/velocity_x.dart';

class UpdateOrderScreen extends StatefulWidget {
  const UpdateOrderScreen({super.key, required this.order});
  final OrderModel order;

  @override
  State<UpdateOrderScreen> createState() => _UpdateOrderScreenState();
}

class _UpdateOrderScreenState extends State<UpdateOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: defaultPadding, horizontal: 40),
        child: Column(
          children: [
            Card(
              shape: ContinuousRectangleBorder(),
              child: Row(
                mainAxisAlignment: Responsive.isDesktop(context)
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(widget.order.images[0],
                      height: 100, width: 100),
                  Column(
                    children: [
                      Text(widget.order.title),
                      Text('Price: ${widget.order.price}'),
                      Text('Quantity: ${widget.order.quantity}')
                    ],
                  ),
                ],
              ),
            ),
            Card(
              shape: ContinuousRectangleBorder(),
              child: Container(
                padding: EdgeInsets.all(Responsive.isDesktop(context) ? 16 : 4),
                width: context.screenWidth,
                child: Column(
                  children: [
                    Text('Address -',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24)),
                        
                  ],
                ),
              ),
            ),
            Center(
              child: DropdownButton(
                items: items,
                onChanged: (value) {
                  currentValue = value;
                  setState(() {});
                },
                value: currentValue,
              ),
            ),
            FilledButton(onPressed: () {}, child: Text('Update Info'))
          ],
        ),
      ),
    );
  }

  String currentValue = 'PLACED';

  List<DropdownMenuItem> items = [
    DropdownMenuItem(value: 'PLACED', child: Text('Placed')),
    DropdownMenuItem(value: 'SHIPPED', child: Text('Shipped')),
    DropdownMenuItem(value: 'DELIVERED', child: Text('Delivered'))
  ];
}
