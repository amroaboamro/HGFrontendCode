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
     });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id : json['_id'],
      serviceName: json['serviceName'],
      price: json['price'],
      note: json['note'],
      status: json['status'],
      date: json['date'],
      userName: json['userName'],
      workerName: json['workerName'],
      street: json['street'],
      city: json['city'],
      carModel: json['carModel'],
    );
  }

}
//price,serviceName,status,userName,workerName,note,city,street,carModel,
