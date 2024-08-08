import 'package:customer/pages/Awaiting.dart';
import 'package:customer/pages/Canceled.dart';
import 'package:customer/pages/Completed.dart';
import 'package:customer/pages/Pending.dart';
import 'package:customer/pages/login.dart';
import 'package:customer/pages/notification.dart';
import 'package:customer/pages/profile.dart';
import 'package:flutter/material.dart';

class Status extends StatefulWidget {
  final String token;
  final String customerId;
  const Status({super.key, required this.token, required this.customerId});

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const DrawerHeader(
                  child: Center(
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage: AssetImage('images/Pic.jpg'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(
                    color: Colors.grey[800],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(),
                  child: ListTile(
                    leading: Icon(
                      Icons.contact_emergency,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Contact for Support',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile(
                                  token: widget.token,
                                  
                                )));
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(),
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Profile',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(),
                  child: ListTile(
                    leading: Icon(
                      Icons.language,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Change Language',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(),
                  child: ListTile(
                    leading: Icon(
                      Icons.password,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Change Password',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(),
                  child: ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Setting',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 25, bottom: 25),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Good Morning, ',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Wilson Lo',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Notifications()));
              },
              child: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
            )
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Awaiting',
            ),
            Tab(
              text: 'Pending',
            ),
            Tab(
              text: 'Completed',
            ),
            Tab(
              text: 'Canceled',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Awaiting(),
          Pending(),
          Completed(),
          Canceled(),
        ],
      ),
    );
  }
}
