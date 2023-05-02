import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:head_gasket/user/Cart.dart';
import '../Classes/Product.dart';
import 'carDetails.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  TextEditingController _searchController = TextEditingController();
  bool _showSearchBar = false;

  List<String> _brands = [
    'Toyota',
    'Honda',
    'Ford',
    'Chevrolet',
    'BMW',
    'Mercedes-Benz',
    'Tesla',
  ];
  List<String> _colors = [
    'Red',
    'Blue',
    'Silver',
    'Black',
    'Yellow',
    'Green',
    'White',
    'Gray',
  ];
  String? _selectedBrand;
  String? _selectedColor;

  List<Product> _products=[];
  @override
  void initState() {
    super.initState();

  }


  Future<List<Product>> fetchProducts() async {
    // final response = await http.get(Uri.parse(''));
    // if (response.statusCode == 200) {
    //   List<dynamic> data = json.decode(response.body);
    //   List<Product> products = data.map((json) => Product.fromJson(json)).toList();
    //   return products;
    // } else {
    //   throw Exception('Failed to load products');
    // }
    return Future.delayed(Duration(seconds: 1),(){
      List<dynamic> data = json.decode('''
      [
  {
    "id": 1,
    "brand": "BMW",
    "model": "X5",
    "color": "Black",
    "price": 50000,
    "imageUrl": "https://cdn.pixabay.com/photo/2017/03/27/14/56/auto-2179220_960_720.jpg"
  },
  {
    "id": 2,
    "brand": "Mercedes",
    "model": "C-Class",
    "color": "White",
    "price": 45000,
    "imageUrl": "https://cdn.pixabay.com/photo/2017/03/27/14/56/auto-2179220_960_720.jpg"
  },
  {
    "id": 3,
    "brand": "Audi",
    "model": "A6",
    "color": "Silver",
    "price": 55000,
    "imageUrl": "https://cdn.pixabay.com/photo/2017/03/27/14/56/auto-2179220_960_720.jpg"
  },
  {
    "id": 4,
    "brand": "Toyota",
    "model": "Camry",
    "color": "Gray",
    "price": 25000,
    "imageUrl": "https://cdn.pixabay.com/photo/2017/03/27/14/56/auto-2179220_960_720.jpg"
  },
  {
    "id": 5,
    "brand": "Honda",
    "model": "Accord",
    "color": "Blue",
    "price": 30000,
    "imageUrl": "https://cdn.pixabay.com/photo/2017/03/27/14/56/auto-2179220_960_720.jpg"
  },
  {
    "id": 6,
    "brand": "Lexus",
    "model": "RX",
    "color": "Black",
    "price": 45000,
    "imageUrl": "https://cdn.pixabay.com/photo/2017/03/27/14/56/auto-2179220_960_720.jpg"
  },
  {
    "id": 7,
    "brand": "Ford",
    "model": "Mustang",
    "color": "Red",
    "price": 40000,
    "imageUrl": "https://cdn.pixabay.com/photo/2017/03/27/14/56/auto-2179220_960_720.jpg"
  },
  {
    "id": 8,
    "brand": "Chevrolet",
    "model": "Camaro",
    "color": "Yellow",
    "price": 35000,
    "imageUrl": "https://cdn.pixabay.com/photo/2017/03/27/14/56/auto-2179220_960_720.jpg"
  },
  {
    "id": 9,
    "brand": "Tesla",
    "model": "Model S",
    "color": "White",
    "price": 80000,
    "imageUrl": "https://cdn.pixabay.com/photo/2017/03/27/14/56/auto-2179220_960_720.jpg"
  }
  ]
      
      ''');
        List<Product> products = data.map((json) => Product.fromJson(json)).toList();
        return products;


    });

  }

  String _searchQuery = '';

  bool _isProductsFetched = false;

  Future<List<Product>> get _filteredProducts async {
    if (!_isProductsFetched) {
      _products = await fetchProducts();
      _isProductsFetched = true;
    }

    List<Product> filteredProducts = [..._products];

    if (_selectedBrand != null) {
      filteredProducts =
          filteredProducts.where((product) => product.brand == _selectedBrand).toList();
    }

    if (_selectedColor != null) {
      filteredProducts =
          filteredProducts.where((product) => product.color == _selectedColor).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((product) =>
      product.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.model.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filteredProducts;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount =
        (screenWidth / 200).floor(); // 200 is the width of the card

    return Scaffold(
      appBar: AppBar(
        title: Text('Store'),
        centerTitle: true,
        backgroundColor: mainColor,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                     CartPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Wrap(
                spacing: 8.0,
                children: _brands.map((brand) {
                  return FilterChip(
                    label: Text(
                      brand,
                      style: TextStyle(
                        color: _selectedBrand == brand
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                    selected: _selectedBrand == brand,
                    selectedColor: Colors.blueGrey,
                    onSelected: (selected) {
                      setState(() {
                        _selectedBrand = selected ? brand : null;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Wrap(
                spacing: 8.0,
                children: _colors.map((color) {
                  return FilterChip(
                    label: Text(
                      color,
                      style: TextStyle(
                        color: _selectedColor == color
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                    selected: _selectedColor == color,
                    selectedColor: Colors.blueGrey,
                    onSelected: (selected) {
                      setState(() {
                        _selectedColor = selected ? color : null;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            if (_showSearchBar)
              Container(
                padding: EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for a car',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
    FutureBuilder<List<Product>>(
    future: _filteredProducts,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        List<Product> products = snapshot.data!;
        return
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.7,
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.75,
              ),
              itemCount: products?.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CarDetailsPage(product: products[index]),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            products[index].imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[index].brand,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                products[index].model,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                              Text(
                                '\$${products[index].price
                                    .toString()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    color: Colors.white,
                  ),
                );
              },
            ),
          );
      }
    }
    ),


          ],
        ),
      ),
    );
  }
}

