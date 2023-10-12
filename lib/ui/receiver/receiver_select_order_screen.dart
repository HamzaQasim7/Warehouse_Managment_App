import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiverSelectOrders extends StatefulWidget {
  const ReceiverSelectOrders({super.key});

  @override
  State<ReceiverSelectOrders> createState() => _ReceiverSelectOrdersState();
}

class _ReceiverSelectOrdersState extends State<ReceiverSelectOrders> {
  bool isChecked = false;

  Widget _buildListItem(int position) {
    String supplierName = faker.person.name();
    DateTime arrivalTime =
    DateTime.now().add(Duration(minutes: Random().nextInt(3600)));
    String formattedArrivalTime =
    faker.randomGenerator.fromCharSet('asdgsadASF213', 10);
    var customColor;
    return GestureDetector(
      onTap: () {
        setState(() {
          customColor = Colors.blue;
        });
      },
      child: Card(
        color: customColor,
        // color: Colors.blue,
        child: ListTile(
          selectedColor: customColor,
          dense: true,
          title: Text(
            '$supplierName',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            // style: Theme
            //     .of(context)
            //     .textTheme
            //     .subtitle1,
          ),
          subtitle: Text(
            'Order ID: $formattedArrivalTime',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
          trailing: Checkbox(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.red,
                )),
            activeColor: Colors.blue,
            value: true,
            onChanged: (bool? value) {},
            checkColor: Colors.transparent,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available orders'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: 7,
                itemBuilder: (context, index) {
                  return _buildListItem(index);
                }),
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Cancel',
                    ),
                  )),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green
                    ),
                    onPressed: () {},
                    child: Text(
                      'Claim',
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
