import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:second_opinion_app/ui/picker/picker_detail_screen.dart';
import 'package:second_opinion_app/ui/picker/unassigned_order.dart';

class PickerOrderScreen extends StatefulWidget {
  const PickerOrderScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PickerOrderScreenState createState() => _PickerOrderScreenState();
}

class _PickerOrderScreenState extends State<PickerOrderScreen> {
  Faker faker = Faker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>UnassignedOrderScreen()));
      },child: Icon(Icons.add),),
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
        return Material(child: _buildListView());
      },
    );
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
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> PickerDetailScreen()));
      },
      child: ListTile(
        dense: true,
        title: Text(
          '$customerName',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle:  Text(
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
      if (message.isNotEmpty) {
        // FlushbarHelper.createError(
        //   message: message,
        //   title: AppLocalizations.of(context).translate('home_tv_error'),
        //   duration: Duration(seconds: 3),
        // )..show(context);
      }
    });

    return const SizedBox.shrink();
  }
}
