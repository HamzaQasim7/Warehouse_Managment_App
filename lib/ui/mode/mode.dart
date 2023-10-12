import 'package:flutter/material.dart';
import 'package:second_opinion_app/utils/routes/routes.dart';

class ModeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mode'),
      ),
      body: Center(
        child: ButtonGrid(),
      ),
    );
  }
}

class ButtonGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      padding: EdgeInsets.all(16.0),
      children: <Widget>[
        CustomButton(
          icon: Icons.home,
          text: 'Receiver',
          onPressed: () {
            Navigator.pushNamed(context, Routes.receiverPageView);
          },
        ),
        CustomButton(
          icon: Icons.border_all,
          text: 'Put Away',
          onPressed: () {
            Navigator.pushNamed(context, Routes.pageView);
          },
        ),
        CustomButton(
          icon: Icons.front_loader,
          text: 'Picker',
          onPressed: () {
            Navigator.pushNamed(context, Routes.pickerPageView);
          },
        ),
        CustomButton(
          icon: Icons.local_shipping,
          text: 'Delivery Driver',
          onPressed: () {
            Navigator.pushNamed(context, Routes.driverPageView);
          },
        ),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.icon, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).primaryColor.withOpacity(0.3),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 48.0,
            ),
            SizedBox(height: 10.0),
            Text(
              text,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
