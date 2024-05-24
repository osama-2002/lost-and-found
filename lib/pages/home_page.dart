import 'package:flutter/material.dart';
import 'package:mafqodat/pages/home_buttons.dart';
import 'package:mafqodat/pages/home_profile.dart';
import 'package:mafqodat/pages/home_requests.dart';
import 'package:mafqodat/pages/login_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeButtons(),
      const HomeRequests(),
      const HomeProfile(),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      drawer: const Drawer(
        child: Center(
          child: Text(
            "All rights reserved, Mafqodat 2024",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.blueGrey,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.search),
            title: const Text("Requests"),
            selectedColor: Colors.blueGrey,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.blueGrey,
          ),
        ],
      ),
    );
  }
}
