import 'package:flutter/material.dart';
import 'package:head_gasket/Admin/Users.dart';
import 'package:head_gasket/Widget/background.dart';

import 'DashboardPage.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _currentPage = 'Dashboard';

  void _changePage(String pageName) {
    setState(() {
      _currentPage = pageName;
    });
    Navigator.pop(context); // Close the drawer after selecting a page
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: mainColor,
            ),
            child: Text(
              'Drawer Example',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text(
              'Dashboard',
              style: TextStyle(fontSize: 16),
            ),
            selected: _currentPage == 'Dashboard',
            onTap: () {
              _changePage('Dashboard');
            },
            tileColor: _currentPage == 'Dashboard' ? mainColor : null,
            shape: _currentPage == 'Dashboard' ? Border.all(color: mainColor, width: 2) : null,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Users',
              style: TextStyle(fontSize: 16),
            ),
            selected: _currentPage == 'Users',
            onTap: () {
              _changePage('Users');
            },
            tileColor: _currentPage == 'Users' ? mainColor : null,
            shape: _currentPage == 'Users' ? Border.all(color: mainColor, width: 2) : null,
          ),
          ListTile(
            leading: Icon(Icons.work),
            title: Text(
              'Workers',
              style: TextStyle(fontSize: 16),
            ),
            selected: _currentPage == 'Workers',
            onTap: () {
              _changePage('Workers');
            },
            tileColor: _currentPage == 'Workers' ? mainColor : null,
            shape: _currentPage == 'Workers' ? Border.all(color: mainColor, width: 2) : null,
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text(
              'Orders',
              style: TextStyle(fontSize: 16),
            ),
            selected: _currentPage == 'Orders',
            onTap: () {
              _changePage('Orders');
            },
            tileColor: _currentPage == 'Orders' ? mainColor : null,
            shape: _currentPage == 'Orders' ? Border.all(color: mainColor, width: 2) : null,
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text(
              'Products',
              style: TextStyle(fontSize: 16),
            ),
            selected: _currentPage == 'Products',
            onTap: () {
              _changePage('Products');
            },
            tileColor: _currentPage == 'Products' ? mainColor : null,
            shape: _currentPage == 'Products' ? Border.all(color: mainColor, width: 2) : null,
          ),
        ],
      ),
    );
  }
  Widget _buildBody() {
    switch (_currentPage) {
      case 'Dashboard':
        return DashboardPage();
      case 'Users':
        return UsersPage();
      case 'Workers':
        return WorkersPage();
      case 'Orders':
        return OrdersPage();
      case 'Products':
        return ProductsPage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawer Example'),
        backgroundColor: mainColor,
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }
}




class WorkersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Workers Page'),
    );
  }
}

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Orders Page'),
    );
  }
}

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Products Page'),
    );
  }
}
