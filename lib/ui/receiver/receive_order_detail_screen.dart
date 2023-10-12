import 'dart:math';
import 'package:faker/faker.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:second_opinion_app/stores/post/post_store.dart';
import 'package:second_opinion_app/utils/locale/app_localization.dart';
import 'package:second_opinion_app/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../scanner/scanner.dart';

class ReceiveOrderDetailScreen extends StatefulWidget {
  @override
  _ReceiveOrderDetailScreenState createState() => _ReceiveOrderDetailScreenState();
}

class _ReceiveOrderDetailScreenState extends State<ReceiveOrderDetailScreen> {
  //stores:---------------------------------------------------------------------

  Faker faker = Faker();

  Map<String, String> selectedRow = {};

  String? qrScan ;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Orders'),
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Card(
            elevation: 0,
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order Information',
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 24),
                      ),

                    ],
                  ),
                ),

                _buildBorderedListTile(
                  title: 'Procurement ID',
                  trailing: '1',
                ),
                Divider(),
                _buildBorderedListTile(
                  title: 'Total Price',
                  trailing: '50',
                ),             Divider(),
                _buildBorderedListTile(
                  title: 'Name of the User',
                  trailing: 'John Doe',
                ),             Divider(),

              ],
            ),
          ),
          Card(
            elevation: 0,
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            child: Column(
              children: [
                _buildBorderedChild(
                  disableBottom: true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Data Table',
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 24),
                        ),
                        Text('Horizontally Scrollable')
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildDataTableView(
                    orderContents,
                  ),),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBorderedChild({required Widget child, bool? disableBottom}) {
    return child;
  }

  bool mapsAreEqual(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    if (map1['partCode'] != map2['partCode']) {
      return false;
    }

    return true;
  }

  Widget _buildDataTableView(List<Map<String, String>> data) {
    return DataTable(
      columns: [
        DataColumn(label: Text('')),
        DataColumn(label: Text('Internal Part Code/SKU')),
        DataColumn(label: Text('Product Name (English)')),
        DataColumn(label: Text('Alternate Name')),
        DataColumn(label: Text('Units in Order')),
        DataColumn(label: Text('Inventory Location')),
      ],
      rows: data.map((item) {
        return DataRow(

            selected: mapsAreEqual(item, selectedRow),
            onLongPress: () {
              _showDialog(context);
              setState(() {
                selectedRow = item;
              });
            },
            cells: [
              DataCell(ElevatedButton(

                  onPressed: () {

                    setState(() {
                      selectedRow = {};
                    });
                  },
                  child: Text('Reset'))),
              DataCell(Text(item['partCode'] ?? '')),
              DataCell(Text(item['productName'] ?? '')),
              DataCell(Text(item['alternateName'] ?? '')),
              DataCell(Text(item['unitsInOrder'] ?? '')),
              DataCell(Text(item['inventoryLocation'] ?? '')),
            ]);
      }).toList(),
    );
  }

  Widget _buildBorderedListTile({
    required String title,
    required String trailing,
    Function()? onTap,
  }) {
    return ListTile(
      title: Text(title,style: TextStyle(fontWeight: FontWeight.bold),),
      trailing: Text(trailing),
      onTap: onTap,
    );
  }

  Widget _buildListItem(int position) {
    String supplierName = faker.person.name();
    DateTime arrivalTime = DateTime.now().add(Duration(minutes: Random().nextInt(3600)));
    String formattedArrivalTime = DateFormat('dd, MMM yyyy hh:mm a').format(arrivalTime);
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiveOrderDetailScreen()));
      },
      dense: true,
      title: Text(
        '$supplierName',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        'Time of Arrival: $formattedArrivalTime',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
      trailing: Checkbox(
        value: true,
        onChanged: (bool? value) {},
        checkColor: Colors.transparent,
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuantityDialog();
      },
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




class QuantityDialog extends StatefulWidget {
  @override
  _QuantityDialogState createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  String? qrScan;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Quantity'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Enter Quantity'),
          ),
          SizedBox(height: 20),
          qrScan == null
              ? Center(
            child: ElevatedButton(
              onPressed: () {
                // Perform the scan action here
                Navigator.push(context, MaterialPageRoute(builder: (context) => QRViewExample())).then((value) {
                  if (value != null) {
                    setState(() {
                      qrScan = value;
                      print('object');
                    });
                  }
                }); // Close the dialog
              },
              child: Text('Scan Code'),
            ),
          )
              : Text('Scanned Code : $qrScan'),
        ],
      ),
    );
  }
}
