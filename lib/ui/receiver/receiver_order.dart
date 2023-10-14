import 'dart:math';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:second_opinion_app/ui/receiver/receiver_order_detail_screen.dart';
import 'package:second_opinion_app/ui/receiver/receiver_unassigned_order.dart';

class ReceiverOrderScreen extends StatefulWidget {
  const ReceiverOrderScreen({super.key});

  @override
  State<ReceiverOrderScreen> createState() => _ReceiverOrderScreenState();
}

class _ReceiverOrderScreenState extends State<ReceiverOrderScreen> {
  Widget _buildListItem(int position) {
    String supplierName = faker.person.name();
    String formattedArrivalTime = faker.randomGenerator.fromCharSet('abcdefgABCDEFG1234567890', 10);
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiverOrderDetailScreen()));
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
        'Order ID: $formattedArrivalTime',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //
      //   Navigator.push(context,MaterialPageRoute(builder: (context)=>ReceiverUnassignedOrderScreen()));
      //
      // },child: Icon(Icons.add),),
      body: ListView.separated(
          itemBuilder: (context, index) {
        return _buildListItem(index);
      },separatorBuilder: (context, index) {
        return Divider();

      },itemCount: 20,),
    );
  }
}
