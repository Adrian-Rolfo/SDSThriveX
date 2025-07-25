import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/globals.dart';
import '../../providers/user_provider.dart';
import '../features/calendar_screen.dart';
import '../features/project_approval_screen.dart';
import '../../widgets/search_bar.dart';

class MyDashBoardScreen extends StatefulWidget {
  const MyDashBoardScreen({super.key});

  @override
  State<MyDashBoardScreen> createState() => _MyDashBoardScreenState();
}

class _MyDashBoardScreenState extends State<MyDashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              // header background
              Container(
                color: theme.primaryColor,
                child: Row(
                  children: [
                    buildSearchBar('Search'),
                    buildSearchButton(context),
                  ],
                ),
              ),

              //  Scrollable content below the fixed header
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 10),
                  children: [
                    const SizedBox(height: 10),
                    buildMyUserTypeButtons(context),
                    const SizedBox(height: 10),
                    if (userProvider.type == UserType.coach ||
                        userProvider.type == UserType.professor) ...[
                      buildMyCardCertifyProjects(context),
                      const SizedBox(height: 10),
                      if (userProvider.type == UserType.coach) ...[
                        buildMyCardCalendar(context),
                        const SizedBox(height: 10),
                      ],
                    ],
                    buildMyCard1(context),
                    const SizedBox(height: 10),
                    buildMyCard2(context),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildMyUserTypeButtons(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context);

  return Padding(
    padding: const EdgeInsets.only(right: 8, left: 8),
    child: Wrap(
      spacing: 8,
      children:
          UserType.values.map((userType) {
            return ElevatedButton(
              onPressed: () {
                userProvider.setUserTheme(userType);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    userType == userProvider.type
                        ? Colors.blue
                        : Colors.white70,
              ),
              child: Text(userType.name),
            );
          }).toList(),
    ),
  );
}

// COACHES ONLY
Widget buildMyCardCertifyProjects(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Color.fromARGB(255, 244, 163, 97), width: 2),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 10,
          top: 12,
          bottom: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Certify Projects', //coaches only
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyPendingProjectScreen(),
                      ),
                    );
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 118, 195, 247),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.black),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            Text(
              'Certify student projects so that they are recognized by employers',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ),
  );
}

// COACHES ONLY
Widget buildMyCardCalendar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.orange, width: 2),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 10,
          top: 12,
          bottom: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calendar',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyCalendarScreen(),
                      ),
                    );
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 118, 195, 247),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.black),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            Text(
              'Certify student projects so that they are recognized by employers',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildMyCard1(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.orange, width: 2),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 10,
          top: 12,
          bottom: 12,
        ),
        child: ExpansionTile(
          title: Text(
            'View Portfolio',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          shape: const Border(),
          collapsedShape: const Border(),
          children: [
            ...[
              '- Personal Projects',
              '- Work Experience',
              '- Volunteer Work',
              '- Certifications & Degrees',
              '- Personal Stories',
            ].map(
              (text) => Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0.0,
                    vertical: 4.0,
                  ),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildMyCard2(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.orange, width: 2),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 10,
          top: 12,
          bottom: 12,
        ),
        child: ExpansionTile(
          title: Text(
            'Upcoming Meetings',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          shape: const Border(),
          collapsedShape: const Border(),
          children: [
            ...['- Coaching Sessions', '- Job Interviews', '- Seminars'].map(
              (text) => Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0.0,
                    vertical: 4.0,
                  ),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
