import 'dart:convert';
import 'package:fhaair/model/AirQuality.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CityModel extends ChangeNotifier {
  String _city = 'Aachen';
  AirQuality _airQuality;

  String get city => this._city;

  void setCity(String city) {
    this._city = city;
    fetchData();
    notifyListeners();
  }

  AirQuality get airQuality => this._airQuality;

  Future<void> fetchData() async {
    Map ambee = await rootBundle.loadStructuredData<Map<String, dynamic>>(
        "assets/ambee.json", (String s) async => json.decode(s));

    var city = await ambeeCall(
        ambee["api_token"],
        //"latest/by-postal-code?postalCode=10115&countryCode=DE");
        "latest/by-city?city=" + this.city);

    var ed = await ambeeCall(
        ambee["api_token"],
        "latest/by-postal-code?postalCode=" +
            city['stations'][0]["postalCode"] +
            "&countryCode=" +
            city['stations'][0]["countryCode"]);

    this._airQuality = AirQuality.fromJson(ed['stations'][0]);

    notifyListeners();
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
}
