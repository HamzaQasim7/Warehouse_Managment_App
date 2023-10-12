import 'dart:math';
import 'package:faker/faker.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:intl/intl.dart';
import 'package:second_opinion_app/ui/driver/unassigned_deliveries.dart';
import 'package:second_opinion_app/ui/task/task_detail.dart';
import 'package:second_opinion_app/ui/task/unassiged_task.dart';
import 'package:second_opinion_app/stores/post/post_store.dart';
import 'package:second_opinion_app/utils/locale/app_localization.dart';
import 'package:second_opinion_app/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'delivery_detail.dart';

class DeliveryScreen extends StatefulWidget {
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  //stores:---------------------------------------------------------------------
  late PostStore _postStore;

  Faker faker = Faker();

  @override
  void initState() {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => UnassignedDeliveryScreen()));
        },
        child: Icon(Icons.add),
        shape: CircleBorder(),
      ),
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
        ? ListView.builder(
      padding: EdgeInsets.all(8),
            itemCount: _postStore.postList!.posts!.length,

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
    String supplierName = faker.person.name();
    DateTime arrivalTime = DateTime.now().add(Duration(minutes: Random().nextInt(3600)));
    String location = '${faker.address.streetAddress()}, ${faker.address.city()}';
    return Card(elevation: 0,
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryDetailScreen()));
          },
          dense: true,
          title: Text(
            '$supplierName',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [ RichText(
              text: TextSpan(

                children: <TextSpan>[
                  TextSpan(
                      text: 'State : ',
                      style:Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 16)
                  ),
                  TextSpan(
                      text: '${faker.randomGenerator.fromCharSet('LD', 1)}',
                      style: TextStyle(color: Colors.grey.shade700 )

                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
              Row(crossAxisAlignment: CrossAxisAlignment.start,
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

            ],
          ),
          trailing: Checkbox(
            value: true,
            onChanged: (bool? value) {},
            checkColor: Colors.transparent,
          ),
        ),
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
