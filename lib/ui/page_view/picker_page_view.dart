import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../picker/picker_home.dart';
import '../picker/picker_order.dart';
import '../picker/picker_pick_order.dart';


class PickerPageViewScreen extends StatefulWidget {
  const PickerPageViewScreen({super.key});

  @override
  State<PickerPageViewScreen> createState() => _PickerPageViewScreenState();
}

class _PickerPageViewScreenState extends State<PickerPageViewScreen> {
  int currentPageIndex = 0;

  // late ThemeStore _themeStore;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
    // _themeStore = Provider.of<ThemeStore>(context);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _buildBottomNavBar(),
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
      return 'My Picking Tasks';

    }
    else{

      return 'Pick Order';
    }


  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      _buildThemeButton(),
      // _buildLogoutButton(),
    ];
  }

  Widget _buildThemeButton() {
    return Observer(
      builder: (context) {
        return IconButton(
          onPressed: () {

            // _themeStore.changeBrightnessToDark(!_themeStore.darkMode);
          },
          icon: const Icon(
            Icons.brightness_5,
            // _themeStore.darkMode ? Icons.brightness_5 : Icons.brightness_3,
          ),
        );
      },
    );
  }

  // Widget _buildLogoutButton() {
  //   return IconButton(
  //     onPressed: () {
  //       SharedPreferences.getInstance().then((preference) {
  //         preference.setBool(Preferences.is_logged_in, false);
  //         Navigator.of(context).pushReplacementNamed(Routes.login);
  //       });
  //     },
  //     icon: Icon(
  //       Icons.power_settings_new,
  //     ),
  //   );
  // }


  Widget _buildCurrentIndexWidget() {
    return <Widget>[
      const PickerHomeScreen(),
      const PickerOrderScreen(),
      const PickerPickOrderScreen()
      // TaskScreen(),
      // PutAwayOrderScreen(),

    ][currentPageIndex];
  }

  List<NavigationDestination> _buildDestinationList() {
    // This function builds the list of navigation destinations, which will be displayed in the bottom navigation bar.
    return [
      const NavigationDestination(
        icon: Icon(
          Icons.house_rounded,
          //color: currentPageIndex == 0 ? Theme.of(context).primaryColor : Colors.black38,
        ),
        label: 'Home',
      ),
      const NavigationDestination(
        icon: Icon(
          Icons.task,
          //color: currentPageIndex == 1 ? Theme.of(context).primaryColor : Colors.black38,
        ),
        label: 'My Picking Tasks',
      ),
      const NavigationDestination(
        icon: Icon(
          Icons.category,
          //color: currentPageIndex == 2 ? Theme.of(context).primaryColor : Colors.black38,
        ),
        label: 'Pick Order',
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
          const UserAccountsDrawerHeader(
            accountName: Text('Account Name'),
            accountEmail: Text('account@gmail.com'),
            currentAccountPicture: FlutterLogo(),
          ),
          ListTile(title: const Text('Pick a New Order'),onTap: (){},)
        ],
      ),
    );
  }
}