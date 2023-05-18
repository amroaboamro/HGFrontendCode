import 'package:flutter/material.dart';
import 'package:head_gasket/Widget/background.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:charts_flutter_new/flutter.dart' as charts;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int usersCount = 20;
  int workersCount = 10;
  int ordersCount = 0;
  int productsCount = 12;
  int servicesCount = 20;
  int carModelsCount = 0;

  late List<charts.Series<Data, String>> _chartData = [];

  @override
  void initState() {
    super.initState();
    _generateChartData();

    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('your_api_url/all_data'));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        setState(() {
          usersCount = responseData['users']['count'];
          workersCount = responseData['workers']['count'];
          ordersCount = responseData['orders']['count'];
          productsCount = responseData['products']['count'];
          servicesCount = responseData['services']['count'];
          carModelsCount = responseData['car_models']['count'];
        });

        _generateChartData();
      } else {
        print('Error fetching data. Status code: ${response.statusCode}');
        // Handle error if necessary
      }
    } catch (error) {
      print('Error fetching data: $error');
      // Handle error if necessary
    }
  }

  void _generateChartData() {
    final data = [
      Data('Users', usersCount),
      Data('Workers', workersCount),
      Data('Orders', ordersCount),
      Data('Products', productsCount),
      Data('Services', servicesCount),
      Data('Car Models', carModelsCount),
    ];
    _chartData = [
      charts.Series<Data, String>(
        id: 'Data',
        domainFn: (Data data, _) => data.label,
        measureFn: (Data data, _) => data.value,
        data: data,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(mainColor),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildChart(),
            SizedBox(height: 20),
            Text(
              'Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDataCard('Users', usersCount),
                _buildDataCard('Workers', workersCount),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDataCard('Orders', ordersCount),
                _buildDataCard('Products', productsCount),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDataCard('Services', servicesCount),
                _buildDataCard('Car Models', carModelsCount),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard(String title, int count) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [mainColor, Colors.blueGrey.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: charts.BarChart(
        _chartData,
        animate: true,
        vertical: true,
        barRendererDecorator: charts.BarLabelDecorator<String>(
          insideLabelStyleSpec: charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
            fontSize: 12,
          ),
          outsideLabelStyleSpec: charts.TextStyleSpec(
            color: charts.MaterialPalette.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class Data {
  final String label;
  final int value;

  Data(this.label, this.value);
}
