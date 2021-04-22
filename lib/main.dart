import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyEnvironment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'My Environmental data'),
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

  @override
  initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    print('loading data...');
    var response = await http.get(
      Uri.parse(
          'https://api.ambeedata.com/latest/by-postal-code?postalCode=3950&countryCode=BE'),
      headers: {
        'x-api-key': 'YOUR-API-KEY-HERE',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(response.body);
      setState(() => {
            environmentalData = jsonResponse['stations'][0],
          });
      //['OZONE'];
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(border: Border.all()),
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              titleRow(
                  environmentalData != null
                      ? environmentalData['placeName']
                      : 'Unknown',
                  'BE'),
              dataRow(
                  'Ozone',
                  environmentalData != null ? environmentalData['OZONE'] : 0,
                  Icon(Icons.bolt, color: Colors.green)),
              dataRow('PM2.5', 15.52, Icon(Icons.bolt, color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleRow(String title, String country) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(country),
        ],
      ),
    );
  }

  Widget dataRow(String title, double value, Icon icon) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value.toString()),
          icon,
        ],
      ),
    );
  }
}
