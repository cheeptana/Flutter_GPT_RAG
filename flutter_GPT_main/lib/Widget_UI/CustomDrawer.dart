import 'package:flutter/material.dart';

import '../Screen/General_Modle_Screen.dart';
import '../Screen/SpecificModelScreen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: const Color(0xFF5c9adb),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('GeneralChat'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GeneralModleScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('SpecificChat'),
            onTap: () {
              Navigator.pop(context);
               Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SpecificModelScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}