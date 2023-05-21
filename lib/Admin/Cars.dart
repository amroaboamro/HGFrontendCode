import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:head_gasket/global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarPage extends StatefulWidget {
  @override
  _CarPageState createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _carBrandController = TextEditingController();

  List<String> carModels = [];
  List<String> carBrands = [];

  @override
  void initState() {
    super.initState();
    _fetchCarData();
  }

  Future<void> _fetchCarData() async {
    final response = await http.get(Uri.parse(global.ip + '/carModels'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        carModels= List<String>.from(data);

      });
    } else {
      throw Exception('Failed to fetch dropdown items');
    }

    final response1 = await http.get(Uri.parse(global.ip + '/carMakers'));
    if (response1.statusCode == 200) {
      final data = json.decode(response1.body);
      print(response1.body);
      setState(() {
       carBrands  =  List<String>.from(data);
      });

    } else {
      throw Exception('Failed to fetch car brands');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Car Brands',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _buildCarBrandsTable(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Car Models',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _buildCarModelsTable(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    

                    onPressed: () {
                      _showCarModelDialog();
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add Car Model'),
                  ),

                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showCarBrandDialog();
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add Car Brand'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarBrandsTable() {
    return SingleChildScrollView(
      child: DataTable(

        columns: [
          DataColumn(label: Text('Brand')),
        ],
        rows: carBrands
            .map(
              (brand) => DataRow(
            cells: [
              DataCell(Text(brand)),
            ],
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildCarModelsTable() {
    return SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(label: Text('Model')),
        ],
        rows: carModels
            .map(
              (model) => DataRow(
            cells: [
              DataCell(Text(model)),
            ],
          ),
        )
            .toList(),
      ),
    );
  }

  Future<void> _showCarModelDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Car Model'),
          content: TextField(
            controller: _carModelController,
            decoration: InputDecoration(hintText: 'Enter Car Model'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  carModels.add(_carModelController.text);
                  _carModelController.clear();
                });
                _addCarModelToApi();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCarBrandDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Car Brand'),
          content: TextField(
            controller: _carBrandController,
            decoration: InputDecoration(hintText: 'Enter Car Brand'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  carBrands.add(_carBrandController.text);
                  _carBrandController.clear();
                });
                _addCarBrandToApi();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addCarModelToApi() async {
    final carModel = _carModelController.text;

    final url = 'https://your-api-url.com/car-models';
    final body = {'carModel': carModel};
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Car model added: $carModel',
        backgroundColor: Colors.green,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );

    } else {
      Fluttertoast.showToast(
        msg: 'Failed to add car model',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<void> _addCarBrandToApi() async {
    final carBrand = _carBrandController.text;

    final url = 'https://your-api-url.com/car-brands';
    final body = {'brand': carBrand};
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Car brand added: $carBrand',
        backgroundColor: Colors.green,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Failed to add car brand',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
