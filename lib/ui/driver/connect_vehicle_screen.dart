import 'dart:math';
import 'package:faker/faker.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:collection/collection.dart';
import 'package:second_opinion_app/ui/task/put_away_order_detail.dart';
import 'package:second_opinion_app/utils/locale/app_localization.dart';
import 'package:second_opinion_app/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../scanner/scanner.dart';

class ConnectVehicleScreen extends StatefulWidget {
  final List<OrderItem> item;

  const ConnectVehicleScreen({super.key, required this.item});

  @override
  _ConnectVehicleScreenState createState() => _ConnectVehicleScreenState();
}

class _ConnectVehicleScreenState extends State<ConnectVehicleScreen> {
  //stores:---------------------------------------------------------------------

  Faker faker = Faker();

  OrderItem selectedRow = OrderItem();

  String? qrScan;

  List<OrderItem> order = [];

  @override
  void initState() {
    setState(() {
      order = widget.item;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Confirm'),
        onPressed: () {},
      ),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Connect Vehicle'),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return false
            ? CustomProgressIndicatorWidget()
            : Material(
                child: _buildListView(),
              );
      },
    );
  }

  String getRandomLocation() {
    List<String> locations = ['Aisle', 'Bay', 'Shelf', 'Bin'];
    Random random = Random();
    int randomIndex = random.nextInt(locations.length);
    return locations[randomIndex];
  }

  Widget _buildListView() {
    List<Map<String, String>> orderContents = [
      {
        'partCode': 'ABC123',
        'productName': 'Product A',
        'alternateName': 'Korean Name',
        'unitsInOrder': '100',
        'inventoryLocation': getRandomLocation(),
      },
      {
        'partCode': 'XYZ789',
        'productName': 'Product B',
        'alternateName': 'Chinese Simplified Name',
        'unitsInOrder': '75',
        'inventoryLocation': getRandomLocation(),
      },
      // Add more data rows as needed
    ];

    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          _buildBorderedChild(
              disableBottom: true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Connect Vehicle',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 30),
                ),
              )),
          qrScan == null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: 80,
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => ConnectVehicleDialog(
                                onPressed: (value) {
                                  setState(() {
                                    qrScan = value;
                                  });
                                },
                              ),
                            );
                          },
                          child: Text('Scan Vehicle Code'))),
                )
              : Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    'Vehicle Code : $qrScan',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                )
        ],
      ),
    );
  }

  Widget _buildBorderedChild({required Widget child, bool? disableBottom}) {
    return child;
  }

  bool mapsAreEqual(OrderItem map1, OrderItem map2) {
    if (map1.partCode != map2.partCode) {
      return false;
    }

    return true;
  }

  Widget _buildDataTableView(List<Map<String, String>> data) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Internal \nPart Code/SKU')),
        DataColumn(label: Text('Product Name \n(English)')),
        DataColumn(label: Text('Alternate \nName')),
        DataColumn(label: Text('Units \nin Order')),
        DataColumn(label: Text('Inventory \nLocation')),
      ],
      rows: (order.mapIndexed((index, item) {
                return DataRow(
                    color: MaterialStateProperty.all(item.quantity == 0 ? Colors.grey.shade300 : null),
                    selected: mapsAreEqual(item, selectedRow),
                    cells: [
                      DataCell(Text(item.partCode.toString() ?? '')),
                      DataCell(Text(item.productNameEn ?? '')),
                      DataCell(Text(item.productNameAlt ?? '')),
                      DataCell(Text(
                        item.quantity.toString() ?? '',
                        style: TextStyle(color: item.quantity! > 0 ? Colors.red : Colors.green),
                      )),
                      DataCell(Text(item.quantity.toString() ?? '')),
                    ]);
              }) ??
              [])
          .toList(),
    );
  }

  Widget _buildBorderedListTile({
    required String title,
    required String trailing,
    Function()? onTap,
  }) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(trailing),
        onTap: onTap,
      ),
    );
  }

  Widget _handleErrorMessage() {
    return SizedBox.shrink();

    // return Observer(
    //   builder: (context) {
    //     if (_postStore.errorStore.errorMessage.isNotEmpty) {
    //       return _showErrorMessage(_postStore.errorStore.errorMessage);
    //     }
    //
    //     return SizedBox.shrink();
    //   },
    // );
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }
}

class ConnectVehicleDialog extends StatefulWidget {
  final Function(String) onPressed;

  const ConnectVehicleDialog({
    super.key,
    required this.onPressed,
  });

  @override
  _ConnectVehicleDialogState createState() => _ConnectVehicleDialogState();
}

class _ConnectVehicleDialogState extends State<ConnectVehicleDialog> {
  String? qrScan;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Scan Vehicle Code'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          qrScan != null
              ? Text(qrScan!)
              : ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => QRViewExample())).then((value) {
                      if (value != null) {
                        setState(() {
                          qrScan = value;
                          widget.onPressed(qrScan ?? '');
                          Navigator.pop(context);
                        });
                      }
                    });
                  },
                  child: Text('Scan'))
        ],
      ),
    );
  }
}
