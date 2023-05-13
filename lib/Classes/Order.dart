class Order {
  final String name;
  final String price;
  final String note;
  final String status;
  final String service;
  final String date;

  Order(
      {required this.name,
        required this.price,
        required this.note,
        required this.status,
        required this.service,
        required this.date});
}