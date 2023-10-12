import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PickerUnassignedOrderScreen extends StatefulWidget {
  const PickerUnassignedOrderScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PickerUnassignedOrderScreenState createState() => _PickerUnassignedOrderScreenState();
}

class _PickerUnassignedOrderScreenState extends State<PickerUnassignedOrderScreen> {
  //stores:---------------------------------------------------------------------

  Faker faker = Faker();

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
      title: const Text('Order'),
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
        return Material(
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
    List<Map<String, Widget>> orderContents = [
      {
        'reset': ElevatedButton(onPressed: () {}, child: const Text('Reset')),
        'partCode': const Text('ABC123'),
        'productName': const Text('Product A'),
        'alternateName': const Text('Korean Name'),
        'unitsInOrder': const Text('100'),
        'inventoryLocation': Text(getRandomLocation()),
      },
      {
        'reset': ElevatedButton(onPressed: () {}, child: const Text('Reset')),
        'partCode': const Text('XYZ789'),
        'productName': const Text('Product B'),
        'alternateName': const Text('Chinese Simplified Name'),
        'unitsInOrder': const Text('75'),
        'inventoryLocation': Text(getRandomLocation()),
      },
      // Add more data rows as needed
    ];

    return ListView(
      children: [
        _buildBorderedListTile(
          title: 'Procurement ID',
          trailing: '1',
        ),
        _buildBorderedListTile(
          title: 'Total Quantity of Boxes',
          trailing: '50',
        ),
        _buildBorderedListTile(
          title: 'Name of the User',
          trailing: 'John Doe',
        ),
        const SizedBox(
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
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontSize: 30),
                  ),
                  const Icon(Icons.forward)
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
            top: BorderSide(
                width: 1.0,
                color: Theme.of(context).dividerColor), // Top border
            bottom: (disableBottom ?? false)
                ? BorderSide.none
                : BorderSide(
                width: 1.0,
                color: Theme.of(context).dividerColor), // Bottom border
          ),
        ),
        child: child);
  }

  Widget _buildDataTableView(List<Map<String, Widget>> data) {
    List<DataRow> rows = data.map((item) {
      return DataRow(cells: [
        DataCell(item['reset'] ?? const SizedBox()),
        // You can use an empty SizedBox if you don't want any content in the first cell
        DataCell(item['partCode'] ?? const Text('')),
        DataCell(item['productName'] ?? const Text('')),
        DataCell(item['alternateName'] ?? const Text('')),
        DataCell(item['unitsInOrder'] ?? const Text('')),
        DataCell(item['inventoryLocation'] ?? const Text('')),
      ]);
    }).toList();

    return DataTable(
      columns: [
        const DataColumn(label: Text('')),
        const DataColumn(label: Text('Internal Part Code/SKU')),
        const DataColumn(label: Text('Product Name (English)')),
        const DataColumn(label: Text('Alternate Name')),
        const DataColumn(label: Text('Units in Order')),
        const DataColumn(label: Text('Inventory Location')),
      ],
      rows: rows,
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
    return const SizedBox.shrink();

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
    Future.delayed(const Duration(milliseconds: 0), () {
      // if (message.isNotEmpty) {
      //   FlushbarHelper.createError(
      //     message: message,
      //     title: AppLocalizations.of(context).translate('home_tv_error'),
      //     duration: Duration(seconds: 3),
      //   )..show(context);
      // }
    });

    return const SizedBox.shrink();
  }
}
