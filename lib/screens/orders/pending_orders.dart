// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notepedixia_admin/const/database.dart';
import 'package:notepedixia_admin/const/constants.dart';
import 'package:notepedixia_admin/const/helper/empty_screen.dart';
import 'package:notepedixia_admin/main.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(
                  title: 'Pending Orders',
                  widget: IconButton(
                    onPressed: () async {
                      await MainClass.init();
                      setState(() {});
                    },
                    icon: const Icon(Icons.refresh),
                  )),
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
          return (localData.value['pending-orders'] ?? []).isEmpty ||
                  localData.value['pending-orders'] == null
              ? const EmptyScreen()
              : ListView.builder(
                  itemBuilder: (context, idx) {
                    final data = localData.value['pending-orders'][idx];
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
                              'Order of ${data['title']} by user - ${data['uid']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            subtitle: Text('Address - ${data['address']}'),
                            onTap: () {
                              final order = OrderModel(
                                address: data['address'],
                                id: data['id'] ?? 'Not Fetched',
                                images: data['images'] ?? [],
                                trackingId: data['trackingId'],
                                price: data['price'] ?? 'Not Fetched',
                                quantity: data['quantity'] ?? 1,
                                status: data['status'] ?? 'Not Fetched',
                                title: data['title'] ?? 'Not Fetched',
                                uid: data['uid'] ?? 'Not Fetched',
                              );
                              Get.to(() =>
                                  UpdateOrderScreen(order: order, index: idx));
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
