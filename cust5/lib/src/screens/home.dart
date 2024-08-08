import 'package:customer/pages/HomePage2.dart';
import 'package:customer/pages/components/bottomnavbar.dart';
import 'package:customer/pages/login.dart';
import 'package:customer/pages/notification.dart';
import 'package:customer/pages/orderpage.dart';
import 'package:customer/pages/profile.dart';
import 'package:customer/pages/request.dart';
import 'package:flutter/material.dart';
import 'package:customer/API/api_login.dart';

class HomePage extends StatefulWidget {
  final String token;
  
  const HomePage({Key? key, required this.token}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late Future<Map<String, dynamic>> _customerDetailsFuture;
  @override
  void initState() {
    super.initState();
    _customerDetailsFuture = _fetchCustomerDetails(widget.token);
    _pages = [
      HomePage2(token: widget.token),
      Requests(token: widget.token),
      OrdersPage(token: widget.token)
    ];
  }
  Future<Map<String, dynamic>> _fetchCustomerDetails(String token) async {
    print('Token: $token');
    try {
      final customerDetails = await NewService().getCustomerByToken(token);
      print('Customer details: $customerDetails');
      return customerDetails;
    } catch (error) {
      print('Error fetching customer details: $error');
      // Show error dialog
      _showErrorDialog('Error fetching customer details: $error');
      throw Exception('Failed to fetch customer details');
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void navigateBottombar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: _customerDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Or any loading widget
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            // Fetch customer name from the snapshot data
            final customerDetails = snapshot.data!['data'] ?? 'Customer';
            return Scaffold(
              backgroundColor: Colors.grey[300],
              bottomNavigationBar: BottomNavBar(
                OnTabChange: (index) => navigateBottombar(index),
              ),
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
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
                    children: [
                      Text(
                        'Good Morning, ',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        customerDetails['name'] ?? '',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Notifications()));
                    },
                    child: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
              body: _pages[_selectedIndex],
            );
          }
          return SizedBox();
        });
  }
}
