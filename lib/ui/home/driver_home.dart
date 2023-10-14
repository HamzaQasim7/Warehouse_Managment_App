import 'dart:math';
import 'package:faker/faker.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:intl/intl.dart';
import 'package:second_opinion_app/utils/locale/app_localization.dart';
import 'package:second_opinion_app/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class DriverHomeScreen extends StatefulWidget {
  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {


  Faker faker = Faker();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _buildBody(),
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
        return false ? CustomProgressIndicatorWidget() : Material(child: _buildListView());
      },
    );
  }

  Widget _buildListView() {
    return   ListView.separated(
      separatorBuilder: (context,position)=>Divider(),
      padding: EdgeInsets.all(8),
      itemCount: 10,
      itemBuilder: (context, position) {
        return _buildListItem(position);
      },
    )
    ;
  }

  Widget _buildListItem(int position) {
    String supplierName = faker.person.name();
    DateTime arrivalTime = DateTime.now().add(Duration(minutes: Random().nextInt(3600)));
    String location = '${faker.address.streetAddress()}, ${faker.address.city()}';
    return ListTile(
      dense: true,
      title: Text(
        '$supplierName',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on,size: 18,),
          Flexible(
            child: Text(
              '$location',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
        ],
      ),
      trailing: Checkbox(
        value: true,
        onChanged: (bool? value) {},
        checkColor: Colors.transparent,
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
