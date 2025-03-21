import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/sharedpref/constants/preferences.dart';
import '../../stores/theme/theme_store.dart';
import '../../utils/routes/routes.dart';
import '../driver/driver_complete_delivery.dart';
import '../driver/load_delivery.dart';
import '../driver/my_deliveries.dart';
import '../home/driver_home.dart';

class DriverPageViewScreen extends StatefulWidget {
  const DriverPageViewScreen({super.key});

  @override
  State<DriverPageViewScreen> createState() => _DriverPageViewScreenState();
}

class _DriverPageViewScreenState extends State<DriverPageViewScreen> {
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

  String _getTitle() {
    if (currentPageIndex == 0) {
      return 'Home';
    } else if (currentPageIndex == 1) {
      return 'My Deliveries';
    } else {
      return 'Pick Order';
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
    return <Widget>[DriverHomeScreen(), DeliveryScreen(), LoadDeliveryScreen(), CompleteDeliveryScreen()][currentPageIndex];
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
        label: 'My Deliveries',
      ),
      NavigationDestination(
        icon: Icon(
          Icons.category,
          //color: currentPageIndex == 2 ? Theme.of(context).primaryColor : Colors.black38,
        ),
        label: 'Pick Order',
      ),
      NavigationDestination(
        icon: Icon(
          Icons.delivery_dining,
          //color: currentPageIndex == 2 ? Theme.of(context).primaryColor : Colors.black38,
        ),
        label: 'Complete Delivery',
      ),
    ];
  }

  NavigationBar _buildBottomNavBar() {
    // This function builds the bottom navigation bar, which allows users to switch between the different pages of the app.
    return NavigationBar(
      height: 100,
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
            title: Text('My Deliveries'),
            onTap: () {
              setState(() {
                currentPageIndex = 1;
                Navigator.pop(context); // Change this line to update the currentPageIndex
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Pick Order'),
            onTap: () {
              setState(() {
                currentPageIndex = 2;
                Navigator.pop(context); // Change this line to update the currentPageIndex
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.delivery_dining),
            title: Text('Complete Delivery'),
            onTap: () {
              setState(() {
                currentPageIndex = 3;
                Navigator.pop(context); // Change this line to update the currentPageIndex
              });
            },
          ),
        ],
      ),
    );
  }
}
