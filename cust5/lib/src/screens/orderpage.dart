import 'package:customer/pages/RequestDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:customer/API/api_login.dart';
import 'package:customer/model/ordermodel.dart';
import 'package:flutter/widgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class OrdersPage extends StatefulWidget {
  final String token;

  const OrdersPage({Key? key, required this.token}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<OrderModel>> _ordersFuture;
  late String customerId;

  @override
  void initState() {
    super.initState();
    // Decode the token to extract customer ID
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      customerId = decodedToken['customer_id'];
    } catch (error) {
      print('Error decoding token: $error');
      // Set a default value for customerId
      customerId = 'default'; // You can choose any default value here
    }

    _ordersFuture = customerId.isNotEmpty
        ? NewService().viewCustomerOrders(widget.token, customerId)
        : Future.value([]);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: 
                   Container(
                    
                    height: 100,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20,top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.problemType,style: TextStyle(fontSize: 12),),
                            SizedBox(height: 20,),
                            Text(order.orderDate,style: TextStyle(fontSize: 12),)
                          ],
                          ),
                          
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Priority:',style: TextStyle(fontSize: 12),),
                                SizedBox(width: 5,),
                                Text(order.urgencyLevel,style: TextStyle(color: Colors.red,fontSize: 12),),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                Text('Status:',style: TextStyle(fontSize: 12),),
                                SizedBox(width: 5,),
                                Text(order.orderStatus,style: TextStyle(fontSize: 12),)
                              ],
                            ),
                            
                          ],
                        ),
                        SizedBox(width: 10,)
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
          } else {
            return const Center(child: Text('No orders available'));
          }
        },
      ),
    );
  }
}
