import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';
import '../Classes/CartManager.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartManager _cartManager;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initCartManager();
  }

  void _initCartManager() async {
    _cartManager = CartManager();
    await _cartManager.loadFromSharedPreferences();
    setState(() {
      _isLoading = false;
    });
  }

  void _onRemoveItemPressed(CartItem item) {
    setState(() {
      _cartManager.removeItem(item.product);
    });
  }

  void _onClearCartPressed() {
    setState(() {
      _cartManager.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        backgroundColor: mainColor,
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _cartManager.items.isEmpty
          ? Center(
        child: Text('Your cart is empty.'),
      )
          : ListView.builder(
        itemCount: _cartManager.items.length,
        itemBuilder: (context, index) {
          CartItem item = _cartManager.items[index];
          return Card(
            elevation: 2.0,
            child: ListTile(
              leading: Image.network(item.product.imageUrl),
              title: Text(
                item.product.description,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.0),
                  Text(
                    'Quantity: ${item.quantity}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Price: \$${item.product.price}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.remove_shopping_cart),
                onPressed: () => _onRemoveItemPressed(item),
              ),
            ),
          );

        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[100],
        child: Container(
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total: \$${_cartManager.items.fold<int>(0, (sum, item) => sum + (item.product.price)*item.quantity)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: implement checkout functionality
                },
                child: Text('Checkout'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal:16.0, vertical: 16.0),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _onClearCartPressed,
                child: Text('Clear cart'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
