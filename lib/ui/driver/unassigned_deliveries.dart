import 'dart:math';
import 'package:faker/faker.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:intl/intl.dart';
import 'package:second_opinion_app/data/sharedpref/constants/preferences.dart';
import 'package:second_opinion_app/ui/task/task_detail.dart';
import 'package:second_opinion_app/utils/routes/routes.dart';
import 'package:second_opinion_app/stores/language/language_store.dart';
import 'package:second_opinion_app/stores/post/post_store.dart';
import 'package:second_opinion_app/stores/theme/theme_store.dart';
import 'package:second_opinion_app/utils/locale/app_localization.dart';
import 'package:second_opinion_app/widgets/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnassignedDeliveryScreen extends StatefulWidget {
  @override
  _UnassignedDeliveryScreenState createState() => _UnassignedDeliveryScreenState();
}

class _UnassignedDeliveryScreenState extends State<UnassignedDeliveryScreen> with TickerProviderStateMixin {
  //stores:---------------------------------------------------------------------
  late PostStore _postStore;
  late ThemeStore _themeStore;
  late LanguageStore _languageStore;

  Faker faker = Faker();

  int selectedIndex = -1;

  List<Map<String, dynamic>> list = [];
  UniqueKey uniqueKey = UniqueKey();

  @override
  void initState() {
    for (int i = 0; i < 10; i++) {
      String supplierName = faker.person.name();
      DateTime arrivalTime = DateTime.now().add(Duration(minutes: Random().nextInt(3600)));
      String location = '${faker.address.streetAddress()}, ${faker.address.city()}';
      list.add({
        'name': supplierName,
        'location': location,
      });
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
    _languageStore = Provider.of<LanguageStore>(context);
    _themeStore = Provider.of<ThemeStore>(context);
    _postStore = Provider.of<PostStore>(context);

    // check to see if already called api
    if (!_postStore.loading) {
      _postStore.getPosts();
    }
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
      title: Text('Unassigned'),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[_buildMainContent(), _buildAnimatedOverlayButton()],
    );
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return _postStore.loading ? CustomProgressIndicatorWidget() : Material(child: _buildListView());
      },
    );
  }

  Widget _buildAnimatedOverlayButton() {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeInOutCirc,
      switchOutCurve: Curves.easeInOutCirc,
      duration: Duration(milliseconds: 300),
      child: selectedIndex >= 0
          ? Align(
              key: uniqueKey,
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedIndex = -1;
                            });
                          },
                          child: Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Add functionality for the second button
                          },
                          child: Text('Claim'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildListView() {
    return _postStore.postList != null
        ? ListView.builder(
            padding: EdgeInsets.only(bottom: 80,top: 8,left: 8,right: 8),
            itemCount: 10,

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
    return Card(
      elevation: 0,
      color: selectedIndex == position ? Color.lerp(Theme.of(context).scaffoldBackgroundColor, Colors.greenAccent, 0.5) : Theme.of(context).primaryColor.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(

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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${list[position]['location']}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              Text(
                'State : L',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
          trailing: Checkbox(
            value: false,
            onChanged: (bool? value) {},
            checkColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
