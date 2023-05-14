import 'package:flutter/material.dart';
import '../Classes/Order.dart';
import '../Widget/background.dart';
import 'OrderDetails.dart';



class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  List<String> filterOptions = ['All', 'Finished', 'Processing', 'Cancelled'];

  String selectedOption = 'All';

  final List<Order> orders = [
    Order(
        name: 'Order 1',
        price: '300',
         note: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        status: 'Finished',
        service: 'Motor',
        date: '05-1-2022'),
    Order(
      name: 'Order 2',
      price: '20',
       note: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      status: 'Processing',
      service: 'Car Wash',
      date: '20-7-2022',
    ),
    Order(
      name: 'Order 3',
      price: '100',
      note: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      status: 'Cancelled',
      service: 'Battery',
      date: '8-4-2023',
    ),
  ];

  List<Order> getFilteredOrders() {
    if (selectedOption == 'All') {
      return orders;
    } else {
      return orders.where((order) => order.status == selectedOption).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: mainColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: filterOptions.map((String option) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: ChoiceChip(
                          label: Text(option),
                          labelStyle: TextStyle(
                            color: selectedOption == option
                                ? Colors.white
                                : Colors.black,
                          ),
                          backgroundColor: selectedOption == option
                              ? mainColor
                              : Colors.grey[300],
                          selectedColor: mainColor,
                          selected: selectedOption == option,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedOption = selected ? option : 'All';
                              // Do something with the selected option
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: getFilteredOrders().length,
              itemBuilder: (BuildContext context, int index) {
                Order order = getFilteredOrders()[index];
                Color statusColor =
                    Colors.grey; // Default color for unknown status
                switch (order.status) {
                  case 'Finished':
                    statusColor = Colors.green;
                    break;
                  case 'Processing':
                    statusColor = Colors.yellow;
                    break;
                  case 'Cancelled':
                    statusColor = Colors.red;
                    break;
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage('assets/images/order.png'),
                                radius: 30,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                order.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Paid :\$ ' + order.price,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    order.date,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    order.status,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  ElevatedButton(
                                    child: Text(
                                      'Details',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white, //background
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                            color: Colors.black, width: 2),
                                      ),

                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OrderDetails(order: order)),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
