import 'package:flutter/material.dart';
import 'package:mallsyok/res/app_config.dart';
import 'package:mallsyok/model/outlet.dart';

class OutletDetailsScreen extends StatefulWidget {
  final Outlet outlet;

  const OutletDetailsScreen({Key key, this.outlet}) : super(key: key);

  @override
  _OutletDetailsScreenState createState() => _OutletDetailsScreenState();
}

class _OutletDetailsScreenState extends State<OutletDetailsScreen> {
  Widget buildBody(double width) {
    return Column(
      children: <Widget>[
        buildImage(width),
        buildOutletName(),
        Divider(height: 8.0,),
        buildCategory(width),
        Divider(height: 8.0,),
        buildFloor(width),
        Divider(height: 8.0,),
        buildUnit(width),
        Divider(height: 8.0,),
        buildContactNumber(width),
        Divider(height: 8.0,),
      ],
    );
  }

  Widget buildOutletName() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.outlet.outletName,
          style: new TextStyle(
            fontSize: 30.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildFloor(double width) {
    return buildDetailsRow(width, "Floor Number", widget.outlet.floorNumber);
  }

  Widget buildUnit(double width) {
    return buildDetailsRow(width, "Unit Number", widget.outlet.unitNumber);
  }

//  Widget buildMallName(double width){
//    return buildDetailsRow(width, "Contact", widget.outlet.contactNumber);
//  }

  Widget buildCategory(double width) {
    return buildDetailsRow(width, "Category", widget.outlet.category);
  }

  Widget buildContactNumber(double width) {
    return buildDetailsRow(width, "Contact", widget.outlet.contactNumber);
  }

  Widget buildDetailsRow(double width, String title, String value) {
    return Row(
      children: <Widget>[
        Container(
          width: width / 3,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              title,
              style: new TextStyle(fontSize: 15.0),
            ),
          ),
        ),
        Container(
          width: width / 3 * 2,
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                value,
                style: new TextStyle(fontSize: 15.0),
              )),
        ),
      ],
    );
  }

  Widget buildImage(double width) {
    return new Container(
      width: width,
      height: 200.0,
      color: Colors.tealAccent,
      child: Align(
        alignment: Alignment.center,
        child: new Text(
          widget.outlet.outletName.substring(0, 1),
          style: new TextStyle(
            fontSize: 100.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          iconSize: 35.0,
          icon: Icon(Icons.chevron_left),
          tooltip: "Back",
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: kColorPink,
        title: new Text(
          widget.outlet.outletName,
          style: new TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: buildBody(width),
    );
  }
}
