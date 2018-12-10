import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceMall {
  // Get list of malls
  void getMallList(Function _onEntryAdded) {
    Firestore.instance
        .collection("Malls")
        .orderBy("mallName", descending: false)
        .snapshots()
        .listen(_onEntryAdded)
        .onError((handleError) {
      print("Error getting mallList");
    });
  }
}
