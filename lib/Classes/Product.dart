class Product {
  final String id;
  final String brand;
  final String name;
  final String type;
  final int price;
  late String imageUrl;
  int quantity;

  Product({required this.id, required this.brand, required this.name, required this.type, required this.price, required this.imageUrl, this.quantity = 1,});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      brand: json['brand'],
      name: json['name'],
      type: json['type'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'brand': brand,
    'name': name,
    'type': type,
    'price': price,
    'imageUrl': imageUrl,
    'quantity':quantity,
  };

  // Description method
  String get description => "$name $brand in $type for $price USD";
}
