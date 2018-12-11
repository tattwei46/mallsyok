import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceOutlet {
  // Get list of malls
  void getOutletList(String mallId, Function _onEntryAdded) {
    Firestore.instance
        .collection("Malls")
        .document(mallId)
        .collection("Outlets")
        .orderBy("outletName", descending: false)
        .snapshots()
        .listen(_onEntryAdded)
        .onError((handleError) {
      print("Error getting outletList");
    });
  }
}
