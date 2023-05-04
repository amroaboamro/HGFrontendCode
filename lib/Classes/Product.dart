class Product {
  final int id;
  final String brand;
  final String model;
  final String color;
  final int price;
  final String imageUrl;
  int quantity;

  Product({required this.id, required this.brand, required this.model, required this.color, required this.price, required this.imageUrl, this.quantity = 1,});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      color: json['color'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'brand': brand,
    'model': model,
    'color': color,
    'price': price,
    'imageUrl': imageUrl,
    'quantity':quantity,
  };

  // Description method
  String get description => "$brand $model in $color color for $price USD";
}