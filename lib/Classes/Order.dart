class Order {
  final String serviceName;
  final double price; //double
  final String note;
  final String status;
  final String date;
  var userName;
  var workerName;
  var street;
  var city;
  var carModel;
  var id;
  var delivery;
  var payment;


  Order(
      {required this.id,required this.serviceName,
      required this.price,
      required this.note,
      required this.status,
      required this.date,
      required this.userName,
      required this.workerName,
      required this.street,
      required this.city,
      required this.carModel,
        required this.delivery,
        required this.payment,
     });

  factory Order.fromJson(Map<String, dynamic> json) {
    int indexOfT = json['date'].indexOf("T");
    String jsonDate = json['date'].substring(0, indexOfT);
    return Order(
      id : json['_id'],
      serviceName: json['serviceName'],
      price: json['price'].toDouble(),
      note: json['note'],
      status: json['status'],
      date: jsonDate,
      userName: json['userName'],
      workerName: json['workerName'],
      street: json['street'],
      city: json['city'],
      carModel: json['carModel'],
      delivery: json['delivery'],
      payment: json['payment'],
    );
  }

}
//price,serviceName,status,userName,workerName,note,city,street,carModel,
