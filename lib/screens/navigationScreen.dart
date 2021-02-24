import 'package:fitness/screens/ProfileScreen.dart';
import 'package:fitness/screens/chatScreen.dart';
import 'package:fitness/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';


class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    ChatScreen(),
    ProfileScreen()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset:false,
      body: _children[_currentIndex],
      bottomNavigationBar: Container(
        color: Colors.grey[900],
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54,width: 2),
              borderRadius: BorderRadius.circular(20)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              bottomLeft:  Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              iconSize: 30,
              onTap: onTabTapped, // new
              currentIndex: _currentIndex,
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.white,
              selectedFontSize: 18,
              unselectedFontSize: 14,
              elevation: 8.0,
              backgroundColor: Colors.grey[900],
              items: [
                BottomNavigationBarItem(
                  icon: new Image.asset("assets/icons/home.png",height: 50),
                  label:'Home',
                ),
                BottomNavigationBarItem(
                  icon: new Image.asset("assets/icons/chat.png",height: 50),
                  label:'Chat',
                ),
                BottomNavigationBarItem(
                    icon: new Image.asset("assets/icons/menu.png",height: 50),
                    label:'Profile'
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
