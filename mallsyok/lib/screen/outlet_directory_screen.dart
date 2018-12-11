import 'package:flutter/material.dart';
import 'package:mallsyok/res/app_config.dart';
import 'package:mallsyok/service/service_mall.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mallsyok/model/mall.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Result { NOT_DETERMINED, FOUND, NOT_FOUND }

class OutletDirectoryPage extends StatefulWidget {
  final Mall mall;

  const OutletDirectoryPage({Key key, this.mall}) : super(key: key);

  @override
  _OutletDirectoryPageState createState() => _OutletDirectoryPageState();
}

class _OutletDirectoryPageState extends State<OutletDirectoryPage> {
  Result resultState = Result.NOT_DETERMINED;
  List<Mall> _outletList = [];

  Widget _searchButton() {
    return IconButton(
      icon: const Icon(Icons.search),
      tooltip: AppConfig.TEXT_SEARCH_MALL,
      onPressed: () {},
    );
  }

  void _onEntryAdded(QuerySnapshot event) {
    if (event.documents.length > 0) {
      _outletList.addAll(
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
      itemCount: _outletList.length,
      itemBuilder: (BuildContext context, int index) {
        return MallCard(mall: _outletList[index]);
      },
    ));
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                  widget.mall.mallName,
                style: new TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: kColorPink,
            ),
          ),
          Divider(),
          ListTile(
            title: Text(AppConfig.TEXT_PROMOTION),
            leading: const Icon(
              FontAwesomeIcons.tags,
            ),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text(AppConfig.TEXT_STORE_DIRECTORY),
            leading: const Icon(
              FontAwesomeIcons.mapSigns,
            ),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text(AppConfig.TEXT_GETTING_THERE),
            leading: const Icon(
              FontAwesomeIcons.mapMarkedAlt,
            ),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text(AppConfig.TEXT_CONTACT_US),
            leading: const Icon(
              FontAwesomeIcons.envelope,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: kColorPink,
        title: new Text(
          widget.mall.mallName,
          style: new TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          _searchButton(),
        ],
      ),
      body: buildBody(),
      drawer: showDrawer(),
    );
  }
}

class MallCard extends StatelessWidget {
  final Mall mall;

  const MallCard({Key key, this.mall}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () => print(mall.mallName),
        child: Column(
          children: <Widget>[
            // TODO : Compress image size
            Container(
              height: 240.0,
              width: width,
              child: CachedNetworkImage(
                imageUrl: mall.mallImagePath,
                placeholder: new Center(child: new CircularProgressIndicator()),
                errorWidget: new Icon(Icons.error),
                fit: BoxFit.fill,
              ),
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
                        mall.mallName,
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
