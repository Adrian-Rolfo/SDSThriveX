import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../features/profile/profile_screen.dart';
import '../features/dashboard_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../providers/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    Widget page;
    switch (currentPageIndex) {
      case 0:
        page = MyNotificationScreen();
        break;
      case 1:
        page = MyDashBoardScreen();
        break;
      case 2:
        page = MyProfileScreen(selectedUserId: userProvider.userId); //Profile
        break;
      default:
        throw UnimplementedError("THIS AINT IMPLEMENTED YET\n");
    }

    return Scaffold(
      body: page,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: currentPageIndex,
        height: 55,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.notifications_none),
            selectedIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
