import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../receiver/receive_order.dart';
import '../receiver/receiver_home.dart';
import '../receiver/receiver_order.dart';



class ReceiverPageViewScreen extends StatefulWidget {
  const ReceiverPageViewScreen({super.key});

  @override
  State<ReceiverPageViewScreen> createState() => _ReceiverPageViewScreenState();
}

class _ReceiverPageViewScreenState extends State<ReceiverPageViewScreen> {
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
      body: _buildCurrentIndexWidget(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(_getTitle()),
      // actions: _buildActions(context),
    );
  }

  String _getTitle(){

    if(currentPageIndex == 0){
      return 'Home';

    } else if(currentPageIndex == 1){
      return 'My Orders';

    }
    else{

      return 'Receive Order';
    }


  }

  Widget _buildCurrentIndexWidget() {
    return <Widget>[
      const ReceiverHomeScreen(),
      const ReceiverOrderScreen(),
      ReceiveOrderScreen(),

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
        label: 'My Orders',
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

  // NavigationBar _buildBottomNavBar() {
  //   // This function builds the bottom navigation bar, which allows users to switch between the different pages of the app.
  //   return NavigationBar(
  //     height: 80,
  //     labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
  //     //backgroundColor: Colors.white,
  //     elevation: 1,
  //     //surfaceTintColor: AppThemeData.lightColorScheme.primary,
  //     destinations: _buildDestinationList(),
  //     selectedIndex: currentPageIndex,
  //     onDestinationSelected: (int index) {
  //       setState(() {
  //         currentPageIndex = index;
  //       });
  //     },
  //   );
  // }

  Drawer _buildDrawer() {

    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Account Name'),
            accountEmail: Text('account@gmail.com'),
            currentAccountPicture: FlutterLogo(),
          ),
          Card(
            elevation: 0,
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: ListTile(
              leading: Icon(Icons.house_rounded),
              title: Text('Home'),
              onTap: () {
                setState(() {
                  currentPageIndex = 0;
                  Navigator.pop(context);
                });
              },
            ),
          ),
          Card(
            elevation: 0,
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: ListTile(
              leading: Icon(Icons.task),
              title: Text('My Orders'),
              onTap: () {
                setState(() {
                  currentPageIndex = 1;
                  Navigator.pop(context);
                });
              },
            ),
          ),
          Card(
            elevation: 0,
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: ListTile(
              leading: Icon(Icons.category),
              title: Text('Receive Order'),
              onTap: () {
                setState(() {
                  currentPageIndex = 2;
                  Navigator.pop(context);
                });
              },
            ),
          )

        ],
      ),
    );
  }
}