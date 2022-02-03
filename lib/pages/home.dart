import 'package:flutter/material.dart';
import 'package:my_tool_box/pages/aboutApp.dart';
import 'package:my_tool_box/pages/calculator/calculator.dart';
import 'package:my_tool_box/pages/hes/hes.dart';
import 'package:my_tool_box/pages/gallery/gallery.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'changeLang.dart';

class Home extends StatefulWidget {
  _homeState createState() => _homeState();
}

class _homeState extends State<Home> {
  int selectedIndex = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tool Box')),
      drawer: SideNav((int index) {
        setState(() {
          selectedIndex = index;
        });
      }, selectedIndex),
      body: Builder(
        builder: (context) {
          switch (selectedIndex) {
            case 0:
              return AboutApp();
            case 1:
              return Gallery();
            case 2:
              return Hes();
            case 3:
              return Calculator();
            case 4:
              return ChangeLang();
            case 5:
              return AboutApp();
            default:
              return Container();
          }
        },
      ),
    );
  }
}

class SideNav extends StatelessWidget {
  final Function onIndexChanged;
  final int selectedIndex;
  SideNav(this.onIndexChanged, this.selectedIndex);

  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Tools',
              style: TextStyle(
                  fontSize: 21, color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            )),
        Divider(color: Colors.grey.shade400),
        ListTile(
          title: Text(AppLocalizations.of(context)!.gallery),
          leading: Icon(Icons.recent_actors),
          selected: selectedIndex == 1,
          onTap: () {
            Navigator.of(context).pop();
            onIndexChanged(1);
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.hes_code),
          leading: Icon(Icons.qr_code_2_rounded),
          selected: selectedIndex == 2,
          onTap: () {
            Navigator.of(context).pop();
            onIndexChanged(2);
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.calculator),
          leading: Icon(Icons.calculate_outlined),
          selected: selectedIndex == 3,
          onTap: () {
            Navigator.of(context).pop();
            onIndexChanged(3);
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.changeLang),
          leading: Icon(Icons.language),
          selected: selectedIndex == 4,
          onTap: () {
            Navigator.of(context).pop();
            onIndexChanged(4);
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.about),
          leading: Icon(Icons.apps),
          selected: selectedIndex == 5,
          onTap: () {
            Navigator.of(context).pop();
            onIndexChanged(5);
          },
        ),
      ],
    ));
  }
}
