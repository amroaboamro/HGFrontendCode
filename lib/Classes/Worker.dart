import 'dart:math' as math;

class Worker {
  String firstName;
  String lastName;
  String name;
  String major;
  double rating;
  String imageUrl;
  String phone;
  String email;
  String city;
  String street;
  String bio;

  var latitude;

  var longitude;

  Worker({
    required this.firstName,
    required this.lastName,
    required this.major,
    required this.rating,
    required this.imageUrl,
    required this.phone,
    required this.email,
    required this.city,
    required this.bio, required this.street, required this.latitude, required this.longitude,
  }) : name = '$firstName $lastName';

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      firstName: json['firstName'],
      lastName: json['lastName'],
      major: json['major'],
      rating: json['rating'].toDouble(),
      imageUrl: json['imageUrl'],
      phone: json['phone'],
      email: json['email'],
      city: json['city'],
      street:json['street'],
      latitude:json['latitude'],
      longitude:json['longitude'],

      bio: json['bio'],
    );
  }

  double distanceTo(double userLat, double userLng) {
    const EARTH_RADIUS = 6371; // in km

    double lat1 = math.pi / 180.0 * this.latitude;
    double lat2 = math.pi / 180.0 * userLat;
    double lng1 = math.pi / 180.0 * this.longitude;
    double lng2 = math.pi / 180.0 * userLng;

    double dlat = lat2 - lat1;
    double dlng = lng2 - lng1;

    double a = math.pow(math.sin(dlat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dlng / 2), 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = EARTH_RADIUS * c;

    return distance;
  }

}

