import 'package:flutter/material.dart';

import '../Classes/Order.dart';
import '../user/OrderDetails.dart';
import 'AcceptWOrderDetailes.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> _orders = [
    Order(
      name: 'Order 1',
      price: '100',
      note: 'Details for Order 1',
      status: 'Requested',
      service: 'Service for Order 1',
      date: '2022-05-13',
    ),
    Order(
      name: 'Order 2',
      price: '200',
      note: 'Details for Order 2',
      status: 'Waiting',
      service: 'Service for Order 2',
      date: '2022-05-14',
    ),
    Order(
      name: 'Order 3',
      price: '300',
      note: 'Details for Order 3',
      status: 'Processing',
      service: 'Service for Order 3',
      date: '2022-05-15',
    ),
    Order(
      name: 'Order 4',
      price: '400',
      note: 'Details for Order 4',
      status: 'Finished',
      service: 'Service for Order 4',
      date: '2022-05-16',
    ),
  ];

  String _selectedStatus = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ranger.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            _buildFilterChips(),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (BuildContext context, int index) {
                  final order = _orders[index];
                  if (_selectedStatus != 'All' &&
                      order.status != _selectedStatus) {
                    return SizedBox.shrink();
                  }

                  return _buildOrderCard(order);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 8.0,
      children: [
        ChoiceChip(
          label: Text('All'),
          selected: _selectedStatus == 'All',
          onSelected: (selected) {
            setState(() {
              _selectedStatus = 'All';
            });
          },
        ),
        ChoiceChip(
          label: Text('Requested'),
          selected: _selectedStatus == 'Requested',
          onSelected: (selected) {
            setState(() {
              _selectedStatus = 'Requested';
            });
          },
        ),
        ChoiceChip(
          label: Text('Waiting'),
          selected: _selectedStatus == 'Waiting',
          onSelected: (selected) {
            setState(() {
              _selectedStatus = 'Waiting';
            });
          },
        ),
        ChoiceChip(
          label: Text('Processing'),
          selected: _selectedStatus == 'Processing',
          onSelected: (selected) {
            setState(() {
              _selectedStatus = 'Processing';
            });
          },
        ),
        ChoiceChip(
          label: Text('Finished'),
          selected: _selectedStatus == 'Finished',
          onSelected: (selected) {
            setState(() {
              _selectedStatus = 'Finished';
            });
          },
        ),
      ],
    );
  }

  Widget _buildOrderCard(Order order) {
    final Color statusColor = _getStatusColor(order.status);
    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderDetails(order: order)),
                );
              },
              child: CircleAvatar(
                radius: 32.0,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                AssetImage('assets/images/order.png'),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.shopping_cart,
                      size: 32.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ${order.name}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text('Car: ${order.note}'),
                  SizedBox(height: 8.0),
                  Text('Service: ${order.service}'),
                  SizedBox(height: 16.0),
                  if (order.status == 'Requested')
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Order Details'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            OrderDetailsWidget(order: order,)
                                          ],
                                        ),
                                      ),

                                    );
                                  },
                                );
                              },
                              child: Text('Accept'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text('Deny'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (order.status != 'Requested')
                    Text(
                      'Status: ${order.status}',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case ''
          '':
        return Colors.blue;
      case 'Waiting':
        return Colors.orange;
      case 'Processing':
        return Colors.yellow;
      case 'Finished':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
