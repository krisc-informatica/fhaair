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
  final double NO2;
  final double PM10;
  final double PM25;
  final double CO;
  final double SO2;
  final double OZONE;
  final int aqi;
  final DateTime updatedAt;
  final AqiInfo aqiInfo;

  AirQuality(
      {this.countryCode,
      this.placeName,
      this.postalCode,
      this.lat,
      this.lng,
      this.NO2,
      this.PM10,
      this.PM25,
      this.CO,
      this.SO2,
      this.OZONE,
      this.aqi,
      this.updatedAt,
      this.aqiInfo});

  AirQuality.fromJson(Map json)
      : countryCode = json["countryCode"],
        placeName = json["placeName"],
        postalCode = json["postalCode"],
        lat = json["lat"],
        lng = json["lng"],
        NO2 = json["NO2"],
        PM10 = json["PM10"],
        PM25 = json["PM25"],
        CO = json["CO"],
        SO2 = json["SO2"],
        OZONE = json["OZONE"],
        aqi = json["AQI"],
        updatedAt = DateTime.tryParse(json["updatedAt"]),
        aqiInfo = AqiInfo.fromJson(json["aqiInfo"]);

  Map<String, dynamic> toMap() => {
        "NO2": this.NO2,
        "PM10": this.PM10,
        "PM25": this.PM25,
        "CO": this.CO,
        "SO2": this.SO2,
        "OZONE": this.OZONE,
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
