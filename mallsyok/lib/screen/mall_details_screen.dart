import 'package:flutter/material.dart';
import 'package:mallsyok/res/app_config.dart';
import 'package:mallsyok/model/mall.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

enum LauncherMode {
  Url,
  PhoneNumber,
  None
}

class MallDetailsScreen extends StatefulWidget {
  final Mall mall;

  const MallDetailsScreen({Key key, this.mall}) : super(key: key);

  @override
  _MallDetailsScreenState createState() => _MallDetailsScreenState();
}

class _MallDetailsScreenState extends State<MallDetailsScreen> {
  List<Option> _optionList = new List<Option>();

  Widget buildBody(double width) {
    return ListView(
      children: <Widget>[
        buildImage(width),
        buildOptions(),
        buildContent(),
      ],
    );
  }

  void buildOptionList() {
    _optionList.add(Option(AppConfig.TEXT_INFORMATION, Icons.info_outline));
    _optionList.add(Option(AppConfig.TEXT_PARKING, Icons.local_parking));
    _optionList.add(Option(AppConfig.TEXT_OPENING_HOURS, Icons.access_time));
  }

  void clearAllOption() {
    for (int i = 0; i < _optionList.length; i++) {
      _optionList[i].isTapped = false;
    }
  }

  Widget buildSingleOption(double containerSize, double iconSize,
      double iconTextSize, Option option, Color color) {
    bool isTapped = option.isTapped;
    return Expanded(
      child: GestureDetector(
        child: new Container(
            height: containerSize,
            width: containerSize,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Icon(
                    option.iconData,
                    size: iconSize,
                    color: isTapped ? color : Colors.black45,
                  ),
                  Text(
                    option.title,
                    style: new TextStyle(
                      fontSize: iconTextSize,
                      color: isTapped ? color : Colors.black45,
                    ),
                  )
                ],
              ),
            )),
        onTap: () {
          setState(() {
            clearAllOption();
            option.isTapped = !option.isTapped;
          });
        },
      ),
    );
  }

  Widget buildContent() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            _optionList[0].isTapped ? buildInfoContent() : buildEmpty(),
            _optionList[1].isTapped ? buildParkingContent() : buildEmpty(),
            _optionList[2].isTapped ? buildOpeningContent() : buildEmpty(),
          ],
        ),
      ),
    );
  }

  Widget buildEmpty() {
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget buildInfoContent() {
    return Column(
      children: <Widget>[
        buildInfoDetails("Address", widget.mall.mallAddress, FontAwesomeIcons.addressBook, LauncherMode.None),
        Container(height: 30.0,),
        buildInfoDetails("Contact Number", widget.mall.mallPhone, FontAwesomeIcons.phone, LauncherMode.PhoneNumber),
        Container(height: 30.0,),
        buildInfoDetails("Website", widget.mall.mallWebsite, Icons.web, LauncherMode.Url),
      ],
    );
  }

  String fixEndline(String inputString) {

    String searchText = "\\n";
    // Check how many endlines in the input string
    int numOfOccurences = searchText.allMatches(inputString).length;

    int endLineIndexTempString = 0;
    int endLineIndexInputString = 0;
    String temp;
    String outputString = "";
    if (numOfOccurences > 0) {
      for (int i=0; i < numOfOccurences; i++) {
        // Get a working string to scan for endline
        temp = inputString.substring(endLineIndexInputString, inputString.length);
        // Get endline index
        endLineIndexTempString = temp.indexOf("\\n", 0);
        // Trim from starting point to endline index and add to output string
        outputString = outputString + temp.substring(0, endLineIndexTempString) +
            "\n";
        // Keep track of endline position in input string
        endLineIndexInputString = endLineIndexInputString + endLineIndexTempString + 2;
      }

      // We add the last section of the string to output
      temp = inputString.substring(endLineIndexInputString, inputString.length);
      outputString = outputString + temp.substring(0, temp.length);

      return outputString;
    } else return inputString;
  }



  void launchURLOrPhoneNumber(String urlOrPhoneNumber, LauncherMode mode) async {
    if (mode == LauncherMode.None) {
      return;
    } else {
      if (mode == LauncherMode.PhoneNumber){
        urlOrPhoneNumber = "tel:" + urlOrPhoneNumber;
      }
    }

    if (urlOrPhoneNumber.length > 0) {
      if (await canLaunch(urlOrPhoneNumber)) {
        await launch(urlOrPhoneNumber);
      } else {
        throw 'Could not launch $urlOrPhoneNumber';
      }
    }
  }

  Widget buildInfoDetails(String header, String body, IconData iconData, LauncherMode mode){
    if (body != null) {
      body = fixEndline(body);
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: <Widget>[
                  Text(
                    header,
                    style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: Icon(iconData),
                  )
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: (){
                    launchURLOrPhoneNumber(body, mode);
                  },
                  child: Text(
                    body,
                    style: new TextStyle(fontSize: 18.0),
                  ),
                ),
              ))
        ],
      );
    } else return buildEmpty();
  }

  Widget buildOpeningDetails(String header, String body, IconData iconData){
    if (body != null) {
      body = fixEndline(body);
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: <Widget>[
                  Text(
                    header,
                    style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: Icon(iconData),
                  )
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  body,
                  style: new TextStyle(fontSize: 18.0),
                ),
              ))
        ],
      );
    } else return buildEmpty();
  }

  Widget buildParkingDetails(String header, String body){
    if (body != null) {
      body = fixEndline(body);
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                header,
                style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  body,
                  style: new TextStyle(fontSize: 18.0),
                ),
              ))
        ],
      );
    } else return buildEmpty();
  }

  Widget buildParkingContent() {
    String parkingWeekday = widget.mall.parkingWeekday;
    String parkingWeekend = widget.mall.parkingWeekend;
    String parkingLost = widget.mall.parkingLost;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Parking Rates",
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        buildParkingDetails("Monday to Friday", parkingWeekday),
        buildParkingDetails("Saturday & Sunday", parkingWeekend),
        buildParkingDetails("Ticket Loss Penalty", parkingLost),
      ],
    );
  }

  Widget buildOpeningContent() {
    return Column(
      children: <Widget>[
        buildOpeningDetails(AppConfig.TEXT_OPENING_HOURS, widget.mall.openingHours, Icons.access_time)
      ],
    );
  }

  Widget buildOptions() {
    double iconSize = 50.0;
    double iconContainerSize = 90.0;
    double iconTextSize = 12.0;
    return new Container(
      padding: EdgeInsets.all(0.0),
      height: iconContainerSize,
      child: Align(
        alignment: Alignment.topRight,
        child: Row(
          children: <Widget>[
            buildSingleOption(iconContainerSize, iconSize, iconTextSize,
                _optionList[0], Colors.pink),
            buildSingleOption(iconContainerSize, iconSize, iconTextSize,
                _optionList[1], Colors.orange),
            buildSingleOption(iconContainerSize, iconSize, iconTextSize,
                _optionList[2], Colors.greenAccent),
          ],
        ),
      ),
    );
  }

  Widget buildImage(double width) {
    return new Container(
      width: width,
      height: 200.0,
      color: Colors.tealAccent,
      child: CachedNetworkImage(
        imageUrl: widget.mall.mallImagePath,
        placeholder: new Center(child: new CircularProgressIndicator()),
        errorWidget: new Icon(Icons.error),
        fit: BoxFit.fill,
      ),
    );
  }

  @override
  void initState() {
    buildOptionList();
    clearAllOption();
    _optionList[0].isTapped = true;
    super.initState();
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
          widget.mall.mallName,
          style: new TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: buildBody(width),
    );
  }
}

class Option {
  String title;
  IconData iconData;
  bool isTapped = false;

  Option(this.title, this.iconData);
}
