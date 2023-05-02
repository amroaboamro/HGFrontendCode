class Service {
  String imgUrl;
  String serviceName;
  String serviceType;

  Service(this.imgUrl, this.serviceName, this.serviceType);
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      json['imgUrl'],
      json['serviceName'],
      json['serviceType'],
    );
  }
}

// List <Worker> workers=[
//   Worker('assets/images/profile.png', 'Amr abo Amr', 'major', 5),
//   Worker('assets/images/profile.png', 'Amr abo Amr', 'major', 4),
//   Worker('assets/images/profile.png', 'Amr abo Amr', 'major', 4),
//   Worker('assets/images/profile.png', 'Amr abo Amr', 'major', 3),
//   Worker('assets/images/profile.png', 'Amr abo Amr', 'major', 2),
// ];
// List <Service> EServices =[
//
//   Service(
//     'assets/images/battery.jpg', 'Battery',workers
// ),
//   Service(
//     'assets/images/flatTire.jpg', 'Flat tire',workers
//   ),
//   Service(
//     'assets/images/key.jpg', 'Center lock',workers
//   ),
//   Service(
//     'assets/images/gasPump.jpeg', 'Fuel ',workers
//   ),
//
//
// ];
// List <Service> MServices =[
//   Service(
//       'assets/images/motor.jpg', 'Motor',workers
//   ),
//   Service(
//       'assets/images/battery.jpg', 'Car diagnostics test',workers
//   ),
//   Service(
//       'assets/images/flatTire.jpg', 'Flat tire',workers
//   ),
//   Service(
//       'assets/images/key.jpg', 'Center lock',workers
//   ),
//   Service(
//       'assets/images/gasPump.jpeg', 'Fuel ',workers
//   ),


//];


