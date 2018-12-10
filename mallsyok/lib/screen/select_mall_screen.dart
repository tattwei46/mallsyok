import 'package:flutter/material.dart';
import 'package:mallsyok/res/app_config.dart';
import 'package:mallsyok/service/service_mall.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mallsyok/model/mall.dart';

enum Result { NOT_DETERMINED, FOUND, NOT_FOUND }

class SelectMallScreen extends StatefulWidget {
  @override
  _SelectMallScreenState createState() => _SelectMallScreenState();
}

class _SelectMallScreenState extends State<SelectMallScreen> {
  Result resultState = Result.NOT_DETERMINED;
  List<Mall> _mallList = [];

  Widget _searchButton() {
    return IconButton(
      icon: const Icon(Icons.search),
      tooltip: AppConfig.TEXT_SEARCH_MALL,
      onPressed: () {},
    );
  }

  void _onEntryAdded(QuerySnapshot event) {
    if (event.documents.length > 0) {
      _mallList.addAll(
          event.documents.map((snapshot) => Mall.fromSnapshot(snapshot)));
      setState(() {
        resultState = Result.FOUND;
      });
    } else {
      if (resultState == Result.NOT_DETERMINED) {
        setState(() {
          resultState = Result.NOT_FOUND;
        });
      }
    }
  }

  @override
  void initState() {
    // Reset result state
    resultState = Result.NOT_DETERMINED;
    // Get mall list
    ServiceMall().getMallList(_onEntryAdded);
    super.initState();
  }

  Widget buildBody() {
    if (resultState == Result.FOUND) {
      return showResult();
    } else if (resultState == Result.NOT_FOUND) {
      return showNoResult();
    }
    return showLoading();
  }

  Widget showNoResult() {
    return new Center(
      child: Text(
        "No Result",
        style: TextStyle(fontSize: 30.0),
      ),
    );
  }

  Widget showLoading() {
    return new Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget showResult() {
    return new Center(
        child: new ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return MallCard();
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: kColorPink,
        title: new Text(
          AppConfig.TEXT_SELECT_MALL,
          style: new TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          _searchButton(),
        ],
      ),
      body: buildBody(),
    );
  }
}

class MallCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return GestureDetector(
        onTap: () => print("tapped"),
        child: Column(
          children: <Widget>[
            Image.asset(
              'images/shopping.jpg',
              height: 240.0,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.black,
              width: width,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Mall",
                        style:
                        new TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
