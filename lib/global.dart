import 'Classes/Order.dart';

class global {
  static bool payment = false;
  static var token = "";
  static var userEmail = '';
  late Order order;

  static Map<String, dynamic> userData = {
    "firstName": "---",
    "lastName": "---",
    "major": "--",
    "rating": 2,
    "imageUrl": "---",
    "phone": "-----",
    "email": "------------",
    "city": "---",
    "street": "----",
    "latitude": 0.0,
    "longitude": 0.0,
    "bio": "-----------------------------------------",
    "carBrand": "-----"
  };
  static var ip =
      "https://node-server-wuse.onrender.com"; //https://node-server-wuse.onrender.com //http://127.0.0.1:3000
  static var Imagetest = "";
}
