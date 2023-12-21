import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notepedixia_admin/const/constants.dart';
import 'package:notepedixia_admin/const/database.dart';
import 'package:notepedixia_admin/const/helper/empty_screen.dart';
import 'package:notepedixia_admin/func/functions.dart';
import 'package:velocity_x/velocity_x.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List nfData = localData.value['notes-filters'];
    List afData = localData.value['all-filters'];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'ShopItems Filters',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Colors.white),
                ),
                TextButton.icon(
                    onPressed: () async {
                      await VxBottomSheet.bottomSheetView(context,
                          child: const CreateFilterWidget(
                            isNotesFilter: false,
                          )).whenComplete(() {
                        setState(() {});
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('New Filter')),
              ]),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: afData.isEmpty
                    ? SizedBox(
                        height: context.height * 0.3,
                        child: const EmptyScreen())
                    : ListView.separated(
                        separatorBuilder: (context, i) {
                          return const Divider();
                        },
                        shrinkWrap: true,
                        itemCount: localData.value['all-filters'].length,
                        itemBuilder: (context, idx) {
                          // All Filters
                          return ListTile(
                            leading: Text((idx + 1).toString()),
                            title: Text(localData.value['all-filters'][idx]),
                            trailing: IconButton(
                                onPressed: () {
                                  ItemsClass.deleteAllFilter(idx, false);
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          );
                        }),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'Notes Filters',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: Colors.white),
                ),
                TextButton.icon(
                    onPressed: () async {
                      await VxBottomSheet.bottomSheetView(context,
                          child: const CreateFilterWidget(
                            isNotesFilter: true,
                          )).whenComplete(() {
                        setState(() {});
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('New Filter')),
              ]),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: nfData.isEmpty
                    ? SizedBox(
                        height: context.screenHeight * 0.3,
                        child: const EmptyScreen())
                    : ListView.separated(
                        separatorBuilder: (context, ind) {
                          return const Divider();
                        },
                        shrinkWrap: true,
                        itemCount: nfData.length,
                        itemBuilder: (context, index) {
                          // Filters for notes
                          return ListTile(
                            leading: Text((index + 1).toString()),
                            title: Text(nfData[index]),
                            trailing: IconButton(
                                onPressed: () {
                                  ItemsClass.deleteAllFilter(index, true);
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          );
                        }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CreateFilterWidget extends StatefulWidget {
  const CreateFilterWidget({super.key, required this.isNotesFilter});
  final bool isNotesFilter;

  @override
  State<CreateFilterWidget> createState() => _CreateFilterWidgetState();
}

class _CreateFilterWidgetState extends State<CreateFilterWidget> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Filter Text'),
            controller: _controller,
          ),
          const SizedBox(height: 20),
          FilledButton(
              onPressed: () {
                if (widget.isNotesFilter == false) {
                  (localData.value['all-filters'] ?? []).add(_controller.text);
                  ItemsClass.createFilters(_controller.text, false);
                } else {
                  (localData.value['notes-filters'] ?? []).add(_controller.text);
                  ItemsClass.createFilters(_controller.text, true);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'))
        ],
      ),
    );
  }
}
