// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:notepedixia_admin/const/database.dart';
import 'package:notepedixia_admin/const/constants.dart';
import 'package:notepedixia_admin/const/helper/empty_screen.dart';
import 'package:notepedixia_admin/models/order_model.dart';
import 'package:notepedixia_admin/const/responsive.dart';
import 'package:notepedixia_admin/screens/dashboard/components/header.dart';
import 'package:notepedixia_admin/screens/orders/components/update_orders.dart';

class PendingOrdersScreen extends StatefulWidget {
  const PendingOrdersScreen({super.key});

  @override
  State<PendingOrdersScreen> createState() => _PendingOrdersScreenState();
}

class _PendingOrdersScreenState extends State<PendingOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              const Header(title: 'Pending Orders', widget: SizedBox()),
              ordersList()
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> items = [
    const DropdownMenuItem(value: 'PLACED', child: Text('Placed')),
    const DropdownMenuItem(value: 'SHIPPED', child: Text('Shipped')),
    const DropdownMenuItem(value: 'DELIVERED', child: Text('Delivered')),
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
          return (localData.value['pending-orders'] ?? []).isEmpty
              ? const EmptyScreen()
              : ListView.builder(
                  itemBuilder: (context, idx) {
                    final data = (localData.value['pending-orders'] ?? [])[idx];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(
                        shape: const ContinuousRectangleBorder(),
                        child: ListTile(
                            isThreeLine: true,
                            leading: Image.network(
                              data['images'][0],
                              width: Responsive.isDesktop(context) ? 100 : 50,
                            ),
                            title: Text(
                              '${data['title']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            subtitle: Text('By user - ${data['uid']}'),
                            onTap: () {
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
                            }),
                      ),
                    );
                  },
                  itemCount: localData.value['pending-orders']!.length,
                  shrinkWrap: true,
                  primary: false,
                );
        },
      ),
    );
  }
}
