import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mallsyok/res/app_config.dart';
import 'package:mallsyok/model/mall.dart';
import 'package:mallsyok/common_widget/platform_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart' as LocationManager;

class DirectionScreen extends StatefulWidget {
  final Mall mall;

  const DirectionScreen({Key key, this.mall}) : super(key: key);

  @override
  _DirectionScreenState createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  GoogleMapController mapController;
  LatLng mallLatLng;

  LatLng parseLatLng(String coordinates) {
    String searchText = ",";
    int index = coordinates.indexOf(searchText, 0);
    double long = 0.0;
    double lat = 0.0;
    lat = double.parse(coordinates.substring(0, index));
    long = double.parse(coordinates.substring(index + 1, coordinates.length).trim());
    LatLng latLng = new LatLng(lat, long);
    print(latLng.latitude.toString() + "," + latLng.longitude.toString());
    return latLng;
  }

  Widget buildBody(double appBarHeight) {
    double mapHeight = MediaQuery.of(context).size.height - appBarHeight - 30.0;
    return Column(
      children: <Widget>[
        Container(
          child: SizedBox(
              height: mapHeight,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                  final markerOptions = MarkerOptions(
                    position: LatLng(mallLatLng.latitude, mallLatLng.longitude),
                    infoWindowText: InfoWindowText(widget.mall.mallName, ""),
                  );
                  controller.addMarker(markerOptions);
                },
                options: GoogleMapOptions(
                  cameraPosition: CameraPosition(
                    target: LatLng(mallLatLng.latitude, mallLatLng.longitude),
                    zoom: 15.0,
                  ),
                ),
              )),
        ),
      ],
    );
  }

  String fixEndline(String inputString) {
    String searchText = "\; ";
    // Check how many endlines in the input string
    int numOfOccurences = searchText.allMatches(inputString).length;

    int endLineIndexTempString = 0;
    int endLineIndexInputString = 0;
    String temp;
    String outputString = "";
    if (numOfOccurences > 0) {
      for (int i = 0; i < numOfOccurences; i++) {
        // Get a working string to scan for endline
        temp =
            inputString.substring(endLineIndexInputString, inputString.length);
        // Get endline index
        endLineIndexTempString = temp.indexOf(searchText, 0);
        // Trim from starting point to endline index and add to output string
        outputString =
            outputString + temp.substring(0, endLineIndexTempString) + "\n";
        // Keep track of endline position in input string
        endLineIndexInputString =
            endLineIndexInputString + endLineIndexTempString + 2;
      }

      // We add the last section of the string to output
      temp = inputString.substring(endLineIndexInputString, inputString.length);
      outputString = outputString + temp.substring(0, temp.length);

      return outputString;
    } else
      return inputString;
  }

  Widget buildTitle() {
    return Text(
      AppConfig.TEXT_GETTING_THERE,
      textAlign: TextAlign.center,
      style: new TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
    );
  }

  Widget buildEmpty() {
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void goToUserLocation() async {
    final getLocation = await getUserLocation();
    final markerOptions = MarkerOptions(
      position: getLocation == null ? LatLng(0, 0) : getLocation,
      infoWindowText: InfoWindowText("Current location", ""),
    );
    mapController.addMarker(markerOptions);
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: getLocation == null ? LatLng(0, 0) : getLocation, zoom: 15.0)));
  }

  Future<LatLng> getUserLocation() async {
    var currentLocation = <String, double>{};
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation["latitude"];
      final lng = currentLocation["longitude"];
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

  Widget buildDetails(String header, String body, IconData iconData) {
    if (body != null && body.length > 0) {
      body = fixEndline(body);
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 30.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  header,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  child: Icon(iconData),
                )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20.0, 0.0, 0.0),
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  body,
                  textAlign: TextAlign.left,
                  style: new TextStyle(fontSize: 16.0),
                ),
              ))
        ],
      );
    } else
      return buildEmpty();
  }

  @override
  void initState() {
    double lat = parseLatLng(widget.mall.mallCoordinates).latitude;
    double long = parseLatLng(widget.mall.mallCoordinates).longitude;
    mallLatLng = new LatLng(lat, long);
    super.initState();
  }

  Future<Widget> _servicesSlideUp() async {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: ListView(
                children: <Widget>[
                  buildTitle(),
                  buildDetails(AppConfig.TEXT_SERVICE_BUS,
                      widget.mall.directionBus, FontAwesomeIcons.bus),
                  buildDetails(AppConfig.TEXT_SERVICE_RAIL,
                      widget.mall.directionRail, FontAwesomeIcons.train),
                  buildDetails(AppConfig.TEXT_SERVICE_MORE,
                      widget.mall.directionService, FontAwesomeIcons.info),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: kAppThemeColor,
      title: new Text(
        widget.mall.mallName,
        style: new TextStyle(color: Colors.white),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.info,
            size: 30.0,
          ),
          tooltip: "Get more information",
          onPressed: () {
            _servicesSlideUp();
          },
        ),
      ],
    );

    return new Scaffold(
      appBar: appBar,
      body: buildBody(appBar.preferredSize.height),
      drawer: PlatformDrawer(
        mall: widget.mall,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToUserLocation();
        },
        tooltip: "Get current location",
        child: new Icon(Icons.my_location),
      ),
    );
  }
}
