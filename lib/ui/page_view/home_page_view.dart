import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:second_opinion_app/ui/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/sharedpref/constants/preferences.dart';
import '../../stores/theme/theme_store.dart';
import '../../utils/routes/routes.dart';
import '../task/put_away_order.dart';
import '../task/task.dart';

class PageViewScreen extends StatefulWidget {
  const PageViewScreen({super.key});

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  int currentPageIndex = 0;

  late ThemeStore _themeStore;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
    _themeStore = Provider.of<ThemeStore>(context);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      resizeToAvoidBottomInset: false,
      //bottomNavigationBar: _buildBottomNavBar(),
      body: _buildCurrentIndexWidget(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(_getTitle()),
      actions: _buildActions(context),
    );
  }

  String _getTitle(){

    if(currentPageIndex == 0){
      return 'Home';

    } else if(currentPageIndex == 1){
      return 'My Orders';

    }
    else{

      return 'Put Away Orders';
    }


  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[

      _buildLogoutButton(),
    ];
  }



  Widget _buildLogoutButton() {
    return IconButton(
      onPressed: () {
        SharedPreferences.getInstance().then((preference) {
          preference.setBool(Preferences.is_logged_in, false);
          Navigator.of(context).pushReplacementNamed(Routes.login);
        });
      },
      icon: Icon(
        Icons.power_settings_new,
      ),
    );
  }


  Widget _buildCurrentIndexWidget() {
    return <Widget>[
      HomeScreen(),
      TaskScreen(),
      PutAwayOrderScreen(),

    ][currentPageIndex];
  }

  List<NavigationDestination> _buildDestinationList() {
    // This function builds the list of navigation destinations, which will be displayed in the bottom navigation bar.
    return [
      NavigationDestination(
        icon: Icon(
          Icons.house_rounded,
          //color: currentPageIndex == 0 ? Theme.of(context).primaryColor : Colors.black38,
        ),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(
          Icons.task,
          //color: currentPageIndex == 1 ? Theme.of(context).primaryColor : Colors.black38,
        ),
        label: 'My Orders',
      ),
      NavigationDestination(
        icon: Icon(
          Icons.category,
          //color: currentPageIndex == 2 ? Theme.of(context).primaryColor : Colors.black38,
        ),
        label: 'Put Away Order',
      ),

    ];
  }

  NavigationBar _buildBottomNavBar() {
    // This function builds the bottom navigation bar, which allows users to switch between the different pages of the app.
    return NavigationBar(
      height: 80,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      //backgroundColor: Colors.white,
      elevation: 1,
      //surfaceTintColor: AppThemeData.lightColorScheme.primary,
      destinations: _buildDestinationList(),
      selectedIndex: currentPageIndex,
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Account Name'),
            accountEmail: Text('account@gmail.com'),
            currentAccountPicture: FlutterLogo(),
          ),
          ListTile(
            leading: Icon(Icons.house_rounded),
            title: Text('Home'),
            onTap: () {
              setState(() {
                currentPageIndex = 0;
                Navigator.pop(context); // Change this line to update the currentPageIndex
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.task),
            title: Text('My Orders'),
            onTap: () {
              setState(() {
                currentPageIndex = 1;
                Navigator.pop(context); // Change this line to update the currentPageIndex
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Put Away Order'),
            onTap: () {
              setState(() {
                currentPageIndex = 2;
                Navigator.pop(context); // Change this line to update the currentPageIndex
              });
            },
          ),

        ],
      ),
    );
  }
}
