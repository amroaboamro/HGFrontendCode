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

  var userEmail;

  var workerEmail;

  var estimatedTime;
  var price1;
  var price2;
  var problem;

  var status2;

  var startingTime;

  var endingTime;

  var remainTime;



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
        required this.payment,this.userEmail,this.workerEmail,this.estimatedTime,this.price1,this.price2,this.problem,this.status2
        ,this.startingTime,this.endingTime,this.remainTime
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
      userEmail: json['userEmail'],
      workerEmail: json['workerEmail'],
      estimatedTime:  json['estimatedTime'],
      price1: json['price1'].toDouble(),
      price2: json['price2'].toDouble(),
      problem: json['problem'],
      status2: json['status2'],
      startingTime:json['startingTime'],
      endingTime: json['endingTime'],
      remainTime: json['remainTime'],

    );
  }

}
//price,serviceName,status,userName,workerName,note,city,street,carModel,
