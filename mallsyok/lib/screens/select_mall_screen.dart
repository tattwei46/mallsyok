import 'package:flutter/material.dart';
import 'package:mallsyok/res/app_config.dart';

class SelectMallScreen extends StatefulWidget {
  @override
  _SelectMallScreenState createState() => _SelectMallScreenState();
}

class _SelectMallScreenState extends State<SelectMallScreen> {
  Widget _searchButton() {
    return IconButton(
      icon: const Icon(Icons.search),
      tooltip: AppConfig.TEXT_SEARCH_MALL,
      onPressed: () {},
    );
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
      body: new Center(
          child: new ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return MallContainer();
        },
      )),
    );
  }
}

class MallContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                    horizontal: 15.0, vertical: 12.0,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Mall", style: new TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
