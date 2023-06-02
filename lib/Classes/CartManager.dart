import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'Product.dart';

class CartItem {
  final Product product;
  int _quantity;

  CartItem({required this.product, required int quantity})
      : _quantity = quantity;

  int get quantity => _quantity;
  set quantity(int value) => _quantity = value;
}

class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  static const String _cartKey = 'cartt';

  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(Product product, int quantity) {
    bool itemFound = false;
    for (CartItem cartItem in _items) {
      if (cartItem.product.id == product.id) {

        cartItem.quantity += quantity;
        itemFound = true;
        break;
      }
    }
    if (!itemFound) {
      final cartItem = CartItem(product: product, quantity: quantity);

      _items.add(cartItem);
    }
    _saveToSharedPreferences();
  }


  void removeItem(Product product) {
    CartItem item = _items.firstWhere((item) => item.product == product);
    item.quantity--;
    if(item.quantity == 0) {
      _items.remove(item);
    }
    _saveToSharedPreferences();
  }

  void clear() {
    _items.clear();
    _saveToSharedPreferences();
  }

  Future<void> loadFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString(_cartKey);
    if (cartData != null) {
      List<dynamic> jsonList = jsonDecode(cartData);

      _items = jsonList.map((e) {
        Product product = Product.fromJson(e['product']);
        print('***********'+product.id);
        int quantity = e['quantity'];
        return CartItem(product: product, quantity: quantity);
      }).toList();
    }
  }

  void _saveToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> jsonList = _items.map((e) => {'product': e.product.toJson(), 'quantity': e.quantity}).toList();
    String jsonString = jsonEncode(jsonList);
    prefs.setString(_cartKey, jsonString);
  }
}
