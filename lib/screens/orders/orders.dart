// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:notepedixia_admin/const/database.dart';
import 'package:notepedixia_admin/constants.dart';
import 'package:notepedixia_admin/models/order_model.dart';
import 'package:notepedixia_admin/responsive.dart';
import 'package:notepedixia_admin/screens/dashboard/components/header.dart';
import 'package:notepedixia_admin/screens/main/main_screen.dart';
import 'package:notepedixia_admin/screens/orders/update_orders.dart';
import 'package:velocity_x/velocity_x.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(title: 'Orders', widget: SizedBox()),
              ordersList()
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> items = [
    DropdownMenuItem(value: 'PLACED', child: Text('Placed')),
    DropdownMenuItem(value: 'SHIPPED', child: Text('Shipped')),
    DropdownMenuItem(value: 'DELIVERED', child: Text('Delivered')),
  ];

  Widget ordersList() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      margin: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ValueListenableBuilder(
        valueListenable: localData,
        builder: (_, value, child) {
          return ListView.builder(
            itemBuilder: (context, idx) {
              final data = (localData.value['orders'] ?? [])[idx];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  shape: ContinuousRectangleBorder(),
                  child: ListTile(
                    isThreeLine: true,
                    leading: Image.network(
                      data['images'][0],
                      width: Responsive.isDesktop(context) ? 100 : 50,
                    ),
                    title: Text(
                      '${data['title']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text('By user - ${data['uid']}'),
                    trailing: Responsive.isDesktop(context)
                        ? SizedBox(
                            width: context.screenWidth * 0.5,
                            child: Row(
                              children: [
                                DropdownButton(
                                  items: items,
                                  onChanged: (newValue) {},
                                  value: 'PLACED',
                                )
                              ],
                            ))
                        : IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_vert),
                          ),
                    onTap: () {
                      if (!Responsive.isDesktop(context)) {
                        final order = OrderModel(
                          id: data['id'] ?? '',
                          images: data['images'] ?? '',
                          longInfo: data['longInfo'] ?? '',
                          price: data['price'] ?? '',
                          quantity: data['quantity'] ?? 1,
                          shortInfo: data['shortInfo'] ?? '',
                          status: data['status'] ?? '',
                          title: data['title'] ?? '',
                          trackingID: data['trackingID'] ?? '',
                          uid: data['uid'] ?? '',
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateOrderScreen(
                                order: order,
                              ),
                            ));
                      }
                    },
                  ),
                ),
              );
            },
            itemCount: localData.value['orders']!.length,
            shrinkWrap: true,
            primary: false,
          );
        },
      ),
    );
  }
}
