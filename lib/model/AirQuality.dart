/// Represents the data coming from Ambee Air Quality api for one station in the result list
/// Sample response
/// {
///   "message": "Success",
///   "stations": [{
///     "NO2": 5.31,
///     "PM10": 52.01,
///     "PM25": 32,
///     "CO": 0.36,
///     "SO2": 2.31,
///     "OZONE": 2.26,
///     "AQI": 93,
///     "updatedAt": "2020-10-07 08:00:00",
///     "aqiInfo": {
///        pollutant:"PM2.5",
///        concentration:32,
///        category:"Moderate"
///     }
///   }]
/// }
class AirQuality {
  final String countryCode;
  final String placeName;
  final String postalCode;
  final double lat;
  final double lng;
  final double no2;
  final double pm10;
  final double pm25;
  final double co;
  final double so2;
  final int aqi;
  final DateTime updatedAt;
  final AqiInfo aqiInfo;

  AirQuality(
      {this.countryCode,
      this.placeName,
      this.postalCode,
      this.lat,
      this.lng,
      this.no2,
      this.pm10,
      this.pm25,
      this.co,
      this.so2,
      this.aqi,
      this.updatedAt,
      this.aqiInfo});

  AirQuality.fromJson(Map json)
      : countryCode = json["countryCode"],
        placeName = json["placeName"],
        postalCode = json["postalCode"],
        lat = json["lat"],
        lng = json["lng"],
        no2 = json["no2"],
        pm10 = json["pm10"],
        pm25 = json["pm25"],
        co = json["co"],
        so2 = json["so2"],
        aqi = json["AQI"],
        updatedAt = DateTime.tryParse(json["updatedAt"]),
        aqiInfo = AqiInfo.fromJson(json["aqiInfo"]);

  Map<String, dynamic> toMap() => {
        "no2": this.no2,
        "pm10": this.pm10,
        "pm25": this.pm25,
        "co": this.co,
        "so2": this.so2
      };
}

class AqiInfo {
  final String pollutant;
  final double concentration;
  final String category;

  AqiInfo({this.pollutant, this.concentration, this.category});

  AqiInfo.fromJson(Map json)
      : pollutant = json["pollutant"],
        concentration = json["concentration"],
        category = json["category"];
}
