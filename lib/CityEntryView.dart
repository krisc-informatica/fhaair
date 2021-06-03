import 'package:fhaair/model/CityModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CityEntryView extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 50),
      padding: EdgeInsets.only(left: 5, top: 5, right: 20, bottom: 00),
      height: 50,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(3),
            topRight: Radius.circular(3),
            bottomLeft: Radius.circular(3),
            bottomRight: Radius.circular(3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            icon: new Icon(Icons.search),
            onPressed: null,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Consumer<CityModel>(builder: (context, model, child) {
              return TextField(
                decoration: InputDecoration.collapsed(hintText: "Enter City"),
                onSubmitted: (text) {
                  print('The city we are looking for is $text!');
                  model.setCity(text);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
