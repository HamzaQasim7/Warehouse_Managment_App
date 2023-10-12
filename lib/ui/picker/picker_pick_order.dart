import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Picker_unassigned_screen.dart';

class PickerPickOrderScreen extends StatefulWidget {
  const PickerPickOrderScreen({super.key});

  @override
  _PickerPickOrderScreenState createState() => _PickerPickOrderScreenState();
}

class _PickerPickOrderScreenState extends State<PickerPickOrderScreen> {
  bool isFabVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: isFabVisible
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PickerUnassignedOrderScreen()));
          setState(() {});
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _buildMainContent(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Material(child: _buildListView());
  }

  Widget _buildListView() {
    return ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, position) {
        return const Divider();
      },
      itemBuilder: (context, position) {
        return _buildListItem(position);
      },
    );
  }

  Widget _buildListItem(int position) {
    String customerName = faker.person.name();
    DateTime arrivalTime =
    DateTime.now().add(Duration(minutes: Random().nextInt(3600)));
    String formattedArrivalTime =
    DateFormat('dd, MMM yyyy hh:mm a').format(arrivalTime);
    bool isHighlighted = false;
    return InkWell(
      onTap: () {
        setState(() {
          isFabVisible = !isFabVisible;
          isHighlighted = isFabVisible;
        });
      },
      child: ListTile(
        tileColor: isHighlighted ? Colors.blue.withOpacity(0.2) : null,
        dense: true,
        title: Text(
          'Supplier Name: $customerName',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          'Arrival Time: $formattedArrivalTime',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
        trailing: Checkbox(
          value: true,
          onChanged: (bool? value) {},
          checkColor: Colors.transparent,
        ),
      ),
    );
  }
}
