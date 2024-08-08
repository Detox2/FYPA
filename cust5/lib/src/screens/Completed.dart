import 'package:flutter/material.dart';

class Completed extends StatefulWidget {
  const Completed({super.key});

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30), // Add space between containers

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20), // Add padding for spacing from edges
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white, // Example of another container
                borderRadius: BorderRadius.circular(20), // Rounded corners
              ),
              child: const Padding(
                padding: EdgeInsets.all(10), // Padding for text
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 20), // Add left padding
                            child: Text(
                              'Autogate',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 20), // Add left padding
                            child: Text(
                              '24/03/24 2:00PM',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20), // Add space between columns
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Priority:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 5), // Add space between the texts
                              Text(
                                'Urgent',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Colors.red, // Set the text color to red
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                'Status:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 5), // Add space between the texts
                              Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Colors.black, // Set the text color to red
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30), // Add space between containers
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20), // Add padding for spacing from edges
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white, // Example of another container
                borderRadius: BorderRadius.circular(20), // Rounded corners
              ),
              child: const Padding(
                padding: EdgeInsets.all(10), // Padding for text
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 20), // Add left padding
                            child: Text(
                              'Autogate',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 20), // Add left padding
                            child: Text(
                              '24/03/24 2:00PM',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20), // Add space between columns
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Priority:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 5), // Add space between the texts
                              Text(
                                'Urgent',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Colors.red, // Set the text color to red
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                'Status:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 5), // Add space between the texts
                              Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      Colors.black, // Set the text color to red
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      backgroundColor: Colors
          .grey[300], // Empty container for now, you can add content if needed
    );
  }
}
