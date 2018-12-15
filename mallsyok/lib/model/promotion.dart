import 'package:cloud_firestore/cloud_firestore.dart';

class Promotion {
  String key;
  String promoName;
  String promoDetails;
  String outletName;
  String mallKey;
  String period;
  String promoImagePath;

  Promotion(
      this.promoName,
      this.promoDetails,
      this.outletName,
      this.mallKey,
      this.period,
      this.promoImagePath
      );

  Promotion.fromSnapshot(DocumentSnapshot snapshot)
      : key = snapshot.documentID,
        promoName = snapshot.data["promoName"],
        promoDetails = snapshot.data["promoDetails"],
        outletName = snapshot.data["outletName"],
        mallKey = snapshot.data["mallKey"],
        period = snapshot.data["period"],
        promoImagePath = snapshot.data["promoImagePath"];
}
