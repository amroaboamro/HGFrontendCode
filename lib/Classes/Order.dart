class Order {
  final String serviceName;
  final double price; //double
  final String note;
  final String status;
  final String date;
  var user;
  var worker;
  var street;
  var city;
  var carModel;
  var id;

  var orderNumber;

  Order(
      {required this.id,required this.serviceName,
      required this.price,
      required this.note,
      required this.status,
      required this.date,
      required this.user,
      required this.worker,
      required this.street,
      required this.city,
      required this.carModel,
      required this.orderNumber});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id : json['_id'],
      orderNumber: json['orderNumber'],
      serviceName: json['serviceName'],
      price: json['price'],
      note: json['note'],
      status: json['status'],
      date: json['date'],
      user: json['user'],
      worker: json['worker'],
      street: json['street'],
      city: json['city'],
      carModel: json['carModel'],
    );
  }

}
//price,serviceName,status,user,worker,note,city,street,carModel,
