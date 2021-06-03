import 'dart:convert';

import 'package:fhaair/AqiDescriptionView.dart';
import 'package:fhaair/AqiSummaryView.dart';
import 'package:fhaair/CityEntryView.dart';
import 'package:fhaair/GradientContainer.dart';
import 'package:fhaair/LastUpdatedView.dart';
import 'package:fhaair/locationView.dart';
import 'package:fhaair/model/AirQuality.dart';
import 'package:fhaair/model/CityModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() {
  // The app is ran with a ChangeNotifierProvider for the 'CityModel' which holds the information about a city
  runApp(
    ChangeNotifierProvider(
      create: (context) => CityModel(),
      child: MyApp(),
    ),
  );
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
            child: Consumer<CityModel>(
              builder: (context, model, child) {
                List p = _buildPage(model);
                return ListView(
                  children: [
                    CityEntryView(),
                    ...p,
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPage(CityModel model) {
    if (model.airQuality != null) {
      return [
        // Text(model.city),
        LocationView(
          longitude:
              model.airQuality.lng ?? 0, // environmentalData["lng"] ?? 0,
          latitude: model.airQuality.lat, // environmentalData["lat"] ?? 0,
          city: model.airQuality.placeName,
        ), //environmentalData["placeName"] ?? ''),
        SizedBox(height: 50),
        AqiSummaryView(),
        SizedBox(height: 140),
        _buildDataRow(model.airQuality, ["CO", "NO2", "OZONE"]),
        _buildDataRow(model.airQuality, ["SO2", "PM10", "PM25"]),
        LastUpdatedView(
          lastUpdatedOn: model.airQuality.updatedAt,
        ),
      ];
    } else {
      return [];
    }
  }

  Widget _buildDataRow(AirQuality data, List labels) {
    Map m = data.toMap();
    print(m);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: labels.map((item) => _buildDataItem(item, m[item])).toList(),
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
