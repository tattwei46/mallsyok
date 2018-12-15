import 'package:flutter/material.dart';
import 'package:mallsyok/res/app_config.dart';
import 'package:mallsyok/model/promotion.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PromoDetailsScreen extends StatefulWidget {
  final Promotion promo;

  const PromoDetailsScreen({Key key, this.promo}) : super(key: key);

  @override
  _PromoDetailsScreenState createState() => _PromoDetailsScreenState();
}

class _PromoDetailsScreenState extends State<PromoDetailsScreen> {
  Widget buildBody(double width) {
    return Column(
      children: <Widget>[
        buildImage(width),
        buildPromoName(),
        Divider(height: 8.0,),
        buildPromoDetails(width),
        Divider(height: 8.0,),
      ],
    );
  }

  Widget buildPromoName() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.promo.outletName,
          style: new TextStyle(
            fontSize: 25.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildPromoDetails(double width) {
    //return buildDetailsRow(width, "Description", widget.promo.promoDetails);
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Description",
              style: new TextStyle(fontSize: 18.0),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.promo.promoDetails,
            style: new TextStyle(fontSize: 15.0),
          ),
        )
      ],
    );
  }

  Widget buildImage(double width) {
    return Container(
      width: width,
      child: AspectRatio(
        aspectRatio: 487 / 451,
        child: CachedNetworkImage(
          imageUrl: widget.promo.promoImagePath,
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
          widget.promo.outletName,
          style: new TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: buildBody(width),
    );
  }
}
