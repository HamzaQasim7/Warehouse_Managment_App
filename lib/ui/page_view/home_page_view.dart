import 'package:flutter/material.dart';
import 'package:second_opinion_app/ui/home/home.dart';

class PageViewScreen extends StatefulWidget {
  const PageViewScreen({super.key});

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _buildBottomNavBar(),
      body: _buildCurrentIndexWidget(),
    );
  }

  Widget _buildCurrentIndexWidget() {
    return <Widget>[
      HomeScreen(),
      Container(
        color: Colors.blueAccent,
      ),
      // OrderHistory(),
      Container(
        color: Colors.grey,
      ),
      Container(
        color: Colors.grey,
      ),
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
        label: 'Dashboard',
      ),
      NavigationDestination(
        icon: Icon(
          Icons.map_outlined,
          //color: currentPageIndex == 1 ? Theme.of(context).primaryColor : Colors.black38,
        ),
        label: 'Leads',
      ),
      NavigationDestination(
        icon: Icon(
          Icons.category,
          //color: currentPageIndex == 2 ? Theme.of(context).primaryColor : Colors.black38,
        ),
        label: 'Tasks',
      ),
      NavigationDestination(
        icon: Icon(
          Icons.person,
          // color: currentPageIndex == 3 ? Theme.of(context).primaryColor : Colors.black38,
        ),
        label: 'Profile',
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
