import 'dart:convert';
import 'dart:math';
import 'package:faker/faker.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:second_opinion_app/stores/post/post_store.dart';
import 'package:second_opinion_app/ui/task/put_away_confirmation_screen.dart';
import 'package:second_opinion_app/utils/locale/app_localization.dart';
import 'package:second_opinion_app/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../scanner/scanner.dart';
import '../task/put_away_order_detail.dart';

class ReceiveOrderDetailScreen extends StatefulWidget {
  @override
  _ReceiveOrderDetailScreenState createState() => _ReceiveOrderDetailScreenState();
}

class _ReceiveOrderDetailScreenState extends State<ReceiveOrderDetailScreen> {
  //stores:---------------------------------------------------------------------

  Faker faker = Faker();

  OrderItem selectedRow = OrderItem();

  String? qrScan;

  List<Order> order = [];

  Future<List<Order>> loadOrders() async {
    // Load the JSON file
    String data = await rootBundle.loadString('assets/lang/my_orders_get_return.json');

    // Decode the JSON data
    List<dynamic> jsonList = json.decode(data);
    print(jsonList);
    // Convert the JSON data to a list of objects
    List<Order> orders = Order.fromJsonList(jsonList);
    order = orders;
    setState(() {});
    return orders;
  }

  Future<void> reset(int index) async {
    // Load the JSON file
    String data = await rootBundle.loadString('assets/lang/my_orders_get_return.json');

    // Decode the JSON data
    List<dynamic> jsonList = json.decode(data);
    print(jsonList);
    // Convert the JSON data to a list of objects
    List<Order> orders = Order.fromJsonList(jsonList);

    order[0].orderItems![index] = orders[0].orderItems![index];

    setState(() {});

  }

  @override
  void initState() {
    loadOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PutAwayOrderConfirmationScreen(
                    item: order[0].orderItems ?? [],
                  )));
        },
        label: Text('Confirm'),
      ),
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

    return ListView(
      children: [
        _buildBorderedListTile(
          title: 'Procurement ID',
          trailing: (order[0].orderId ?? 0).toString(),
        ),
        _buildBorderedListTile(
          title: 'Total Price',
          trailing: '50',
        ),
        _buildBorderedListTile(
          title: 'Name of the User',
          trailing: order[0].supplierName ?? '',
        ),
        SizedBox(
          height: 50,
        ),
        _buildBorderedChild(
            disableBottom: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Data Table',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 30),
                  ),
                  Icon(Icons.forward)
                ],
              ),
            )),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildBorderedChild(
              child: _buildDataTableView(
                orderContents,
              ),
            ))
      ],
    );
  }

  Widget _buildBorderedChild({required Widget child, bool? disableBottom}) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Theme.of(context).dividerColor), // Top border
            bottom:
            (disableBottom ?? false) ? BorderSide.none : BorderSide(width: 1.0, color: Theme.of(context).dividerColor), // Bottom border
          ),
        ),
        child: child);
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
        DataColumn(label: Text('')),
        DataColumn(label: Text('Internal \nPart Code/SKU')),
        DataColumn(label: Text('Product Name \n(English)')),
        DataColumn(label: Text('Alternate \nName')),
        DataColumn(label: Text('Units \nin Order')),
        DataColumn(label: Text('Total \nPrice')),
      ],
      rows: (order[0].orderItems?.mapIndexed((index, item) {
        return DataRow(
            color: MaterialStateProperty.all(item.quantity == 0 ? Colors.grey.shade300 : null),
            selected: mapsAreEqual(item, selectedRow),
            onLongPress: () async {
              if (item.quantity != 0) {
                _showDialog(context).then((value) {
                  if (value['code'] != item.barcode.toString()) {
                    setState(() {
                      item.quantity = (item.quantity ?? 0) - int.parse(value['quantity']!);
                    });
                  }
                });
                setState(() {
                  selectedRow = item;
                });
              }
            },
            cells: [
              DataCell(ElevatedButton(
                  onPressed: () {
                    setState(() {
                      reset(index);
                    });
                  },
                  child: Text('Reset'))),
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

  Future<Map<String, String?>> _showDialog(BuildContext context) async {
    return await showDialog(
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

  List<String> options = ['1'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Quantity'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildDropdownWidget(options),
          SizedBox(height: 20),
          qrScan == null
              ? ElevatedButton(
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
          )
              : Text('Scanned Code : $qrScan'),
          qrScan != null
              ? ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {'quantity': dropdownValue, 'code': qrScan});
              },
              child: Text('Confirm'))
              : SizedBox.shrink()
        ],
      ),
    );
  }

  String dropdownValue = '1';

  Widget buildDropdownWidget(List<String> options) {
    // Initially selected value

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black, fontSize: 16),
        underline: Container(
          height: 2,
          color: Colors.transparent,
        ),
        onChanged: (String? newValue) {
          dropdownValue = newValue!;
        },
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
//
// class Order {
//   String? supplierName;
//   int? orderId;
//   List<OrderItem>? orderItems;
//   String? expectedArrival;
//   bool? assigned;
//
//   Order({this.supplierName, this.orderId, this.orderItems, this.expectedArrival, this.assigned});
//
//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       supplierName: json['supplierName'],
//       orderId: json['orderId'],
//       orderItems: json['orderItems'] != null ? List<OrderItem>.from(json['orderItems'].map((x) => OrderItem.fromJson(x))) : null,
//       expectedArrival: json['expectedArrival'],
//       assigned: json['assigned'],
//     );
//   }
//
//   static List<Order> fromJsonList(List<dynamic> jsonList) {
//     return jsonList.map((json) => Order.fromJson(json)).toList();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['supplierName'] = this.supplierName;
//     data['orderId'] = this.orderId;
//     if (this.orderItems != null) {
//       data['orderItems'] = this.orderItems!.map((v) => v.toJson()).toList();
//     }
//     data['expectedArrival'] = this.expectedArrival;
//     data['assigned'] = this.assigned;
//     return data;
//   }
// }
//
// class OrderItem {
//   int? partCode;
//   int? barcode;
//   String? productNameEn;
//   String? productNameAlt;
//   int? quantity;
//
//   OrderItem({this.partCode, this.barcode, this.productNameEn, this.productNameAlt, this.quantity});
//
//   factory OrderItem.fromJson(Map<String, dynamic> json) {
//     return OrderItem(
//       partCode: json['partCode'],
//       barcode: json['barcode'],
//       productNameEn: json['product_name_en'],
//       productNameAlt: json['product_name_alt'],
//       quantity: json['quantity'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['partCode'] = this.partCode;
//     data['barcode'] = this.barcode;
//     data['product_name_en'] = this.productNameEn;
//     data['product_name_alt'] = this.productNameAlt;
//     data['quantity'] = this.quantity;
//     return data;
//   }
// }
