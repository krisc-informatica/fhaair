import 'dart:convert';

import 'package:fhaair/AqiDescriptionView.dart';
import 'package:fhaair/AqiSummaryView.dart';
import 'package:fhaair/CityEntryView.dart';
import 'package:fhaair/GradientContainer.dart';
import 'package:fhaair/LastUpdatedView.dart';
import 'package:fhaair/locationView.dart';
import 'package:fhaair/model/Airquality.dart';
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
  // 1
  // var environmentalData;
  // var pollen;

  // 2
  // AirQuality environmentalData;

  // 3
  Future<AirQuality> environmentalData;

  @override
  initState() {
    // environmentalData = Map();
    // pollen = Map();
    environmentalData = loadAirQuality();
    super.initState();
  }

  Future<AirQuality> loadAirQuality() async {
    // waits for the rootBundle to load the json asset and then parses the file to a Map
    Map ambee = await rootBundle.loadStructuredData<Map<String, dynamic>>(
        "assets/ambee.json", (String s) async => json.decode(s));

    var ed = await ambeeCall(ambee["api_token"],
        "latest/by-postal-code?postalCode=10115&countryCode=DE");
    return AirQuality.fromJson(ed['stations'][0]);
  }

  Future<AirQuality> loadPollen() async {
    // waits for the rootBundle to load the json asset and then parses the file to a Map
    Map ambee = await rootBundle.loadStructuredData<Map<String, dynamic>>(
        "assets/ambee.json", (String s) async => json.decode(s));
    print("key: ${ambee['api_token']}"); // For debug purposes to show the key

    // print(aq);
    // var pollen = await ambeeCall(
    //     ambee["api_token"], "/forecast/pollen/by-place?place=Berlin");
    // setState(() => {
    //       pollen = pollen['data'],
    //     });

    return null;
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
            child: FutureBuilder(
              future: environmentalData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: [
                      CityEntryView(),
                      LocationView(
                        longitude: snapshot.data.lng ??
                            0, // environmentalData["lng"] ?? 0,
                        latitude:
                            snapshot.data.lat, // environmentalData["lat"] ?? 0,
                        city: snapshot.data.placeName,
                      ), //environmentalData["placeName"] ?? ''),
                      SizedBox(height: 50),
                      //AqiSummaryView(data: environmentalData),
                      AqiSummaryView(data: snapshot.data),
                      SizedBox(height: 140),
                      // _buildDataRow(environmentalData, ["CO", "NO2", "OZONE"]),
                      // _buildDataRow(environmentalData, ["SO2", "PM10", "PM25"]),
                      _buildDataRow(snapshot.data, ["CO", "NO2", "OZONE"]),
                      _buildDataRow(snapshot.data, ["SO2", "PM10", "PM25"]),
                      LastUpdatedView(
                        lastUpdatedOn: snapshot.data.updatedAt,
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(AirQuality data, List labels) {
    Map m = data.toMap();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: labels.map((item) => _buildDataItem(item, m[item])).toList(),
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
