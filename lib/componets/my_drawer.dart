import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/pages/setting_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
   void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
          
          DrawerHeader(
            child: Center(
            child: Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
              opticalSize: 40,
              
            ),
          ),
           
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: const Text("H O M E"),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
            Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              title: const Text("S E T T I N G S"),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => SettingPage()));
              },
            ),
          ),
            Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              title: const Text("L O G O U T"),
              leading: const Icon(Icons.logout),
              onTap: () {
                
                Navigator.pop(context);
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => LoginPage(onTap: () {})));
                
              },
            ),
          ),
            ],
          ),
        
        ],
      ),
    );
  }
}