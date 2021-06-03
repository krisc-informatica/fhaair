import 'package:fhaair/model/CityModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AqiSummaryView extends StatelessWidget {
  // // final Map data;
  // final AirQuality data;

  // AqiSummaryView({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CityModel>(
      builder: (context, model, child) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    model.airQuality.aqi.toString() ?? '',
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    model.airQuality.aqiInfo != null
                        ? model.airQuality.aqiInfo.pollutant +
                            ': ' +
                            model.airQuality.aqiInfo.concentration.toString()
                        : '',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    _mapAqiToImage(model.airQuality.aqi),
                    Text(
                      model.airQuality.aqiInfo?.category,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              )
              //_mapWeatherConditionToImage(this.condition, this.isdayTime),
            ],
          ),
        );
      },
    );
  }

  Image _mapAqiToImage(int aqi) {
    String asset;
    if (aqi == null || aqi <= 50) {
      asset = 'assets/aqi/aqi_0.png';
    } else if (aqi <= 100) {
      asset = 'assets/aqi/aqi_51.png';
    } else if (aqi <= 150) {
      asset = 'assets/aqi/aqi_101.png';
    } else if (aqi <= 200) {
      asset = 'assets/aqi/aqi_151.png';
    } else if (aqi <= 300) {
      asset = 'assets/aqi/aqi_201.png';
    } else {
      asset = 'assets/aqi/aqi_301.png';
    }
    return Image.asset(asset);
  }
}
