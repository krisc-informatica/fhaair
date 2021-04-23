import 'package:flutter/material.dart';

class AqiDescriptionView extends StatelessWidget {
  final Map data;

  AqiDescriptionView({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Text('${this.data["AQI"].toString()}',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            Text(
              this.data["aqiInfo"] != null
                  ? this.data["aqiInfo"]["pollutant"]
                  : '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              ': ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              this.data["aqiInfo"] != null
                  ? this.data["aqiInfo"]["concentration"].toString()
                  : '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              ' - ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              this.data["aqiInfo"] != null
                  ? this.data["aqiInfo"]["category"]
                  : '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        )
      ]),
    );
  }
}
