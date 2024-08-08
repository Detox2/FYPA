import 'package:customer/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:customer/API/api_login.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Profile extends StatefulWidget {
  final String token;
  
  const Profile({super.key, required this.token});

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  late Future<Map<String, dynamic>> _customerDetailsFuture;
  String? customerId;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController warrantyController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController autoController = TextEditingController();
  TextEditingController alarmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _customerDetailsFuture = _fetchCustomerDetails(widget.token);
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    warrantyController.dispose();
    locationController.dispose();
    autoController.dispose();
    alarmController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _fetchCustomerDetails(String token) async {
    print('Token: $token');
    try {
      final customerDetails = await NewService().getCustomerByToken(token);
      print('Customer details: $customerDetails');

      // Decode the token to extract customer ID
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      print('Decoded Token: $decodedToken');

      if (!decodedToken.containsKey('userId')) {
        throw Exception('Token does not contain userId');
      }

      customerId = decodedToken['userId'].toString();

      // Initialize controllers with existing data
      setState(() {
        usernameController.text = customerDetails['data']['name'] ?? '';
        emailController.text = customerDetails['data']['email'] ?? '';
        phoneController.text = customerDetails['data']['phone_number'] ?? '';
        warrantyController.text = customerDetails['data']['warranty'] ?? '';
        locationController.text = customerDetails['data']['location'] ?? '';
        autoController.text = customerDetails['data']['auto_gate_brand'] ?? '';
        alarmController.text = customerDetails['data']['alarm_brand'] ?? '';
      });

      return customerDetails;
    } catch (error) {
      print('Error fetching customer details: $error');
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

  Future<void> _updateProfile() async {
    final String name = usernameController.text;
    final String location = locationController.text;
    final String email = emailController.text;
    final String warranty = warrantyController.text;
    final String autoGate = autoController.text;
    final String alarm = alarmController.text;
    final String phone = phoneController.text;

    if (customerId == null) {
      _showErrorDialog('Customer ID is not available. Please try again later.');
      return;
    }

    try {
      final response = await NewService().updateCustomerProfile(
        widget.token,
        customerId!,
        name,
        email,
        location,
        alarm,
        autoGate,
        phone,
        warranty,
      );
      print('CustomerId: $customerId where are you');
      if (response.containsKey('status') && response['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile updated successfully'),
        ));
        // Navigate to the home page after saving
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomePage(token: widget.token)));
      } else {
        // Check if the error message indicates customer not found
        if (response.containsKey('message') &&
            response['message'] == 'Customer not found') {
          // Handle customer not found error
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Customer not found. Please refresh the page.'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to update profile'),
          ));
        }
      }

    } catch (error) {
      _showErrorDialog('Error updating profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.red,
      body: FutureBuilder(
        future: _customerDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final customerDetails = snapshot.data!['data'];
            return ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.grey[300],
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: AssetImage('images/Pic.jpg'),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          const Text(
                            'Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Container(
                            color: Colors.white,
                            child: TextField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                border: OutlineInputBorder(),
                                hintText: customerDetails['name'] ?? '',
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Address',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Container(
                            color: Colors.white,
                            child: TextField(
                              controller: locationController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                border: OutlineInputBorder(),
                                hintText: customerDetails['location'] ?? '',
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Email',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Container(
                            color: Colors.white,
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                border: OutlineInputBorder(),
                                hintText: customerDetails['email'] ?? '',
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Autogate Brand',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Container(
                            color: Colors.white,
                            child: TextField(
                              controller: autoController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                border: OutlineInputBorder(),
                                hintText:
                                    customerDetails['auto_gate_brand'] ?? '',
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Alarm Brand',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Container(
                            color: Colors.white,
                            child: TextField(
                              controller: alarmController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                border: OutlineInputBorder(),
                                hintText: customerDetails['alarm_brand'] ?? '',
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Warranty',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Container(
                            color: Colors.white,
                            child: TextField(
                              controller: warrantyController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                border: OutlineInputBorder(),
                                hintText: customerDetails['warranty'] ?? '',
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Phone Number',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Container(
                            color: Colors.white,
                            child: TextField(
                              controller: phoneController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                border: OutlineInputBorder(),
                                hintText:
                                    customerDetails['phone_number'] ?? '',
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: ElevatedButton(
                              onPressed: _updateProfile,
                              child: Text('Update Profile'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
