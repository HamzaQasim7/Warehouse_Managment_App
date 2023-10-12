import 'dart:math';
import 'package:faker/faker.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:intl/intl.dart';
import 'package:second_opinion_app/ui/receiver/receive_order_detail_screen.dart';
import 'package:second_opinion_app/ui/task/put_away_order_detail.dart';
import 'package:second_opinion_app/ui/task/unassiged_task.dart';
import 'package:second_opinion_app/stores/post/post_store.dart';
import 'package:second_opinion_app/utils/locale/app_localization.dart';
import 'package:second_opinion_app/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ReceiveOrderScreen extends StatefulWidget {
  @override
  _ReceiveOrderScreenState createState() => _ReceiveOrderScreenState();
}

class _ReceiveOrderScreenState extends State<ReceiveOrderScreen> {
  //stores:---------------------------------------------------------------------
  late PostStore _postStore;

  Faker faker = Faker();

  int selectedIndex = -1;

  List<Map<String, dynamic>> list = [];
  UniqueKey uniqueKey = UniqueKey();

  @override
  void initState() {
    for (int i = 0; i < 10; i++) {
      String supplierName = faker.person.name();
      DateTime arrivalTime = DateTime.now().add(Duration(minutes: Random().nextInt(3600)));
      String formattedArrivalTime = faker.randomGenerator.fromCharSet('asdgsadASF213', 10);
      list.add({
        'name': supplierName,
        'toa': formattedArrivalTime,
      });
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
    _postStore = Provider.of<PostStore>(context);

    // check to see if already called api
    if (!_postStore.loading) {
      _postStore.getPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: selectedIndex>=0?FloatingActionButton(
        onPressed: () {

          Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceiveOrderDetailScreen()));

        },
        child: Icon(Icons.play_arrow),
        shape: CircleBorder(),
      ):null,

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
        return _postStore.loading ? CustomProgressIndicatorWidget() : Material(child: _buildListView());
      },
    );
  }

  Widget _buildListView() {
    return _postStore.postList != null
        ? ListView.separated(
      itemCount: 10,
      separatorBuilder: (context, position) {
        return Divider();
      },
      itemBuilder: (context, position) {
        return _buildListItem(position);
      },
    )
        : Center(
      child: Text(
        AppLocalizations.of(context).translate('home_tv_no_post_found'),
      ),
    );
  }

  Widget _buildListItem(int position) {
    return ListTile(
      tileColor: selectedIndex == position ? Color.lerp(Theme.of(context).scaffoldBackgroundColor, Colors.greenAccent, 0.5) : null,
      onTap: () {
        if (selectedIndex != position) {
          setState(() {
            selectedIndex = position;
          });
        } else {
          setState(() {
            selectedIndex = -1;
          });
        }
      },
      dense: true,
      title: Text(
        '${list[position]['name']}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        'Order ID: ${list[position]['toa']}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
      trailing: Checkbox(
        value: false,
        onChanged: (bool? value) {},
        checkColor: Colors.transparent,
      ),
    );
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (_postStore.errorStore.errorMessage.isNotEmpty) {
          return _showErrorMessage(_postStore.errorStore.errorMessage);
        }

        return SizedBox.shrink();
      },
    );
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
