import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastUpdatedView extends StatelessWidget {
  final DateTime lastUpdatedOn;

  LastUpdatedView({Key key, @required this.lastUpdatedOn})
      : assert(lastUpdatedOn != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0, left: 00),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time,
            color: Colors.black45,
            size: 15,
          ),
          SizedBox(width: 10),
          Text(
            'Last updated on ${DateFormat("dd-MM-yyyy HH:mm").format(this.lastUpdatedOn)}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
