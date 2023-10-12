import 'dart:math';
import 'package:faker/faker.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:second_opinion_app/utils/locale/app_localization.dart';
import 'package:second_opinion_app/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TaskDetailScreen extends StatefulWidget {
  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
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
      title: Text('Order'),
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



  Widget _buildDataTableView(List<Map<String, String>> data) {
    List<DataRow> rows = data.map((item) {
      return DataRow(cells: [
        DataCell(Text(item['partCode'] ?? '')),
        DataCell(Text(item['productName'] ?? '')),
        DataCell(Text(item['alternateName'] ?? '')),
        DataCell(Text(item['unitsInOrder'] ?? '')),
        DataCell(Text(item['inventoryLocation'] ?? '')),
      ]);
    }).toList();

    return DataTable(
      columns: [
        DataColumn(label: Text('Internal Part Code/SKU')),
        DataColumn(label: Text('Product Name (English)')),
        DataColumn(label: Text('Alternate Name')),
        DataColumn(label: Text('Units in Order')),
        DataColumn(label: Text('Inventory Location')),
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
