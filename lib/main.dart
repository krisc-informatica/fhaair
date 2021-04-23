import 'dart:convert';

import 'package:fhaair/AqiDescriptionView.dart';
import 'package:fhaair/AqiSummaryView.dart';
import 'package:fhaair/CityEntryView.dart';
import 'package:fhaair/GradientContainer.dart';
import 'package:fhaair/LastUpdatedView.dart';
import 'package:fhaair/locationView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FHA Air',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'FHA Air'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var environmentalData;
  var pollen;

  @override
  initState() {
    environmentalData = Map();
    pollen = Map();
    loadData();
    super.initState();
  }

  void loadData() async {
    print('loading data...');

    // waits for the rootBundle to load the json asset and then parses the file to a Map
    Map ambee = await rootBundle.loadStructuredData<Map<String, dynamic>>(
        "assets/ambee.json", (String s) async => json.decode(s));
    print("key: ${ambee['api_token']}"); // For debug purposes to show the key

    var ed = await ambeeCall(ambee["api_token"],
        "latest/by-postal-code?postalCode=10115&countryCode=DE");
    setState(() => {
          environmentalData = ed['stations'][0],
        });
    var pollen = await ambeeCall(
        ambee["api_token"], "/forecast/pollen/by-place?place=Berlin");
    setState(() => {
          pollen = pollen['data'],
        });
  }

  Future<Map<String, dynamic>> ambeeCall(String token, String path) async {
    var response = await http.get(
      Uri.parse('https://api.ambeedata.com/$path'),
      headers: {
        'x-api-key': token,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(response.body);
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        color: Colors.lightBlue,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            // decoration: BoxDecoration(border: Border.all()),
            // padding: EdgeInsets.all(15),
            child: ListView(
              children: [
                CityEntryView(),
                LocationView(
                    longitude: environmentalData["lng"] ?? 0,
                    latitude: environmentalData["lat"] ?? 0,
                    city: environmentalData["placeName"] ?? ''),
                SizedBox(height: 50),
                //AqiDescriptionView(data: environmentalData),
                AqiSummaryView(data: environmentalData),
                SizedBox(height: 140),
                _buildDataRow(environmentalData, ["CO", "NO2", "OZONE"]),
                _buildDataRow(environmentalData, ["SO2", "PM10", "PM25"]),
                LastUpdatedView(
                  lastUpdatedOn: environmentalData["updatedAt"] != null
                      ? DateTime.tryParse(environmentalData["updatedAt"])
                      : DateTime.now(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(Map data, List labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: labels.map((item) => _buildDataItem(item, data[item])).toList(),
      // children: [
      //   _buildDataItem("CO", data["CO"]),
      //   _buildDataItem("NO2", data["NO2"], fractionDigits: 3),
      //   _buildDataItem("Ozone", data["OZONE"]),
      //   _buildDataItem("SO2", data["SO2"]),
      //   _buildDataItem("PM10", data["PM10"]),
      //   _buildDataItem("PM2.5", data["PM25"]),
      // ],
    );
  }

  Widget _buildDataItem(String name, double value, {int fractionDigits = 2}) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(name ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w300)),
          Text(value != null ? value.toStringAsFixed(fractionDigits) : '',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
