import 'package:crowdfunding/screens/discovery_screen.dart';
import 'package:crowdfunding/screens/home_screen.dart';
import 'package:crowdfunding/screens/login_screen.dart';
import 'package:crowdfunding/screens/profile_screen.dart';
import 'package:crowdfunding/widget/edit_profile_dialog.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _pageNames = [
    'Home',
    'Discover',
    'Profile',
  ];

  final List<Widget> _selectedPage = [
    const HomePage(),
    const DiscoverPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    const String docId = 'uqtyFrpmKyJzf3BT4MiQ';
    return Scaffold(
      appBar: AppBar(
          title: Text(_pageNames[_selectedIndex]),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(129, 199, 132, 1),
          actions: [
            PopupMenuButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: const Row(children:  [
                            Icon(
                              Icons.logout_outlined,
                              color: Colors.black,
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ];
                })
          ]),
      body: SingleChildScrollView(
        child: _selectedPage[_selectedIndex],
      ),
      floatingActionButton: Visibility(
        visible: _selectedIndex == 2,
        child: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(129, 199, 132, 1),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EditProfileDialog(docId: docId); // Pass the docId to the dialog
                },
            );
          },
          child: const Icon(Icons.edit),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: const Color.fromRGBO(243, 237, 247, 1.0),
        selectedItemColor: const Color.fromRGBO(0, 0, 0, 1),
        unselectedItemColor: const Color.fromRGBO(0, 0, 0, 1),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            activeIcon: Icon(Icons.home_filled),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Discover',
            activeIcon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
            activeIcon: Icon(Icons.person),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
