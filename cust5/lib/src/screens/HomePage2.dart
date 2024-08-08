import 'package:customer/pages/RequestDetails.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:customer/API/api_login.dart';
import 'package:customer/model/ordermodel.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomePage2 extends StatefulWidget {
  final String token;

  const HomePage2({Key? key, required this.token}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  late Future<List<OrderModel>>
      _latestOrderFuture; // Change to List<OrderModel>
  late String customerId;

  @override
  void initState() {
    super.initState();
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      customerId = decodedToken['userId'].toString();
      print('Customer ID: $customerId');
    } catch (error) {
      print('Error decoding token: $error');

      customerId = 'default'; // Set a default value
    }

    _latestOrderFuture = customerId.isNotEmpty
        ? NewService().getLatestOrder(widget.token, customerId)
        : Future.value([]); // Initialize with empty list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.grey[300],
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 30, bottom: 10),
                  child: Text(
                    'Announcement',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 100,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 5),
                    viewportFraction: 10,
                  ),
                  items: [1, 2, 3, 4, 5].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(color: Colors.white),
                          child: Text(
                            'text $i',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 15),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Current Requests',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    FutureBuilder<List<OrderModel>>(
                      future: _latestOrderFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final List<OrderModel> latestOrders = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: latestOrders.length,
                            itemBuilder: (context, index) {
                              final OrderModel order = latestOrders[index];
                              return ListTile(
                                title: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.red),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.problemType,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          order.orderDate,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          order.orderTime,
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailPage(
                          orderId: order.orderId.toString(),
                          token: widget.token,
                        ),
                      ),
                    );
                                },
                              );
                            },
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 100),
                Column(
                  children: [
                    Center(
                      child: Container(
                        height: 150,
                        width: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            const Center(
                              child: Text(
                                'Service Hour',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Divider(
                                color: Colors.grey[800],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Monday - Friday'),
                                      SizedBox(height: 10),
                                      Text('Saturday - Sunday'),
                                      SizedBox(height: 10),
                                      Text('Public Holiday'),
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('9:00 A.M. to 5:00 P.M.'),
                                      SizedBox(height: 10),
                                      Text('9:00 A.M. to 12:00 P.M.'),
                                      SizedBox(height: 10),
                                      Text('OFF')
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
