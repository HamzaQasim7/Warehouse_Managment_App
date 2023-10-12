import 'package:flutter/material.dart';
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
  var Text1 = ['Home', 'My Orders', 'Receive Orders', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Text1[currentPageIndex]),
        centerTitle: false,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Account Name'),
              accountEmail: Text('account@gmail.com'),
              currentAccountPicture: FlutterLogo(),
            ),
            Card(
              elevation: 0,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: ListTile(
                leading: Icon(Icons.add),
                title: Text('Pick a New Order'),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _buildBottomNavBar(),
      body: _buildCurrentIndexWidget(),
    );
  }

  Widget _buildCurrentIndexWidget() {
    return <Widget>[
      ReceiverHomeScreen(),
      ReceiverOrderScreen(),
      ReceiveOrderScreen(),

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
        label: 'Receive Order',
      ),

    ];
  }

  Widget _buildBottomNavBar() {
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
}
