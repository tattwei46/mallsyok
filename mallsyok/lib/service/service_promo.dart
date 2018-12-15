import 'package:cloud_firestore/cloud_firestore.dart';

class ServicePromo {
  // Get list of malls
  void getPromoList(String mallKey, Function _onEntryAdded) {
    Firestore.instance
        .collection("Promos")
        .where("mallKey", isEqualTo: mallKey)
        .orderBy("promoName", descending: false)
        .snapshots()
        .listen(_onEntryAdded)
        .onError((handleError) {
      print("Error getting promoList");
    });
  }
}
