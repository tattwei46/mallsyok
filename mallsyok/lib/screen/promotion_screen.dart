import 'package:flutter/material.dart';
import 'package:mallsyok/res/app_config.dart';
import 'package:mallsyok/common_widget/platform_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mallsyok/screen/promotion_details_screen.dart';
import 'package:mallsyok/model/promotion.dart';
import 'package:mallsyok/model/mall.dart';
import 'package:mallsyok/service/service_promo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mallsyok/screen/promotion_details_screen.dart';

enum Result { NOT_DETERMINED, FOUND, NOT_FOUND }

class PromotionScreen extends StatefulWidget {
  final Mall mall;

  const PromotionScreen({Key key, this.mall}) : super(key: key);

  @override
  _PromotionScreenState createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  Result resultState = Result.NOT_DETERMINED;
  List<Promotion> _promoList = [];

  Widget buildBody() {
    if (resultState == Result.FOUND) {
      return showResult();
    } else if (resultState == Result.NOT_FOUND) {
      return showNoResult();
    }
    return showLoading();
  }

  void _onEntryAdded(QuerySnapshot event) {
    if (event.documents.length > 0) {
      _promoList.addAll(
          event.documents.map((snapshot) => Promotion.fromSnapshot(snapshot)));
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
    // Get promo list
    ServicePromo().getPromoList(widget.mall.key, _onEntryAdded);

    super.initState();
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
      itemCount: _promoList.length,
      itemBuilder: (BuildContext context, int index) {
        return PromoCard(promo: _promoList[index]);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: kColorPink,
        title: new Text(
          AppConfig.TEXT_PROMOTION,
          style: new TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          //_searchButton(),
        ],
      ),
      body: buildBody(),
      drawer: PlatformDrawer(
        mall: widget.mall,
      ),
    );
  }
}

class PromoCard extends StatelessWidget {
  final Promotion promo;

  const PromoCard({Key key, this.promo}) : super(key: key);

  void navigateOutletDirectory(BuildContext context, Promotion promo) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => PromoDetailsScreen(promo: promo)));
  }

  Widget buildPromoTitle(){
    return Align(
      alignment: Alignment.topLeft,
      child: new Text(
        promo.promoName,
        maxLines: 1,
        style: new TextStyle(
            color: Colors.white, fontSize: 15.0),
      ),
    );
  }

  Widget buildPromoDetails(){
    return new Text(
      promo.promoDetails,
      maxLines: 3,
      style: new TextStyle(
          color: Colors.white, fontSize: 15.0),
    );
  }

  Widget buildOverlayText(double width, double cardHeight, double descHeight){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: cardHeight - descHeight,
            width: width,
            color: Colors.transparent,
          ),
          Container(
            height: descHeight,
            width: width,
            color: Colors.black.withOpacity(0.5),
            alignment: Alignment(-1.0, 1.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  buildPromoTitle(),
                  buildPromoDetails(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPromoImage(double width, double cardHeight){
    return Container(
      height: cardHeight,
      width: width,
      child: AspectRatio(
        aspectRatio: 487 / 451,
        child: CachedNetworkImage(
          imageUrl: promo.promoImagePath,
          placeholder:
          new Center(child: new CircularProgressIndicator()),
          errorWidget: new Icon(Icons.error),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double cardHeight = 240.0;
    double descHeight = 100.0;
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => PromoDetailsScreen(promo: promo)));
        },
        child: Stack(
          children: <Widget>[
            buildPromoImage(width, cardHeight),
            buildOverlayText(width, cardHeight, descHeight),
          ],
        ));
  }
}
