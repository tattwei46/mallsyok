import 'package:cloud_firestore/cloud_firestore.dart';

class Outlet {
  String key;
  String outletName;
  String category;
  String floorNumber;
  String unitNumber;
  String contactNumber;

  Outlet(
      this.outletName,
      this.category,
      this.floorNumber,
      this.unitNumber,
      this.contactNumber,
      );

  Outlet.fromSnapshot(DocumentSnapshot snapshot)
      : key = snapshot.documentID,
        outletName = snapshot.data["outletName"],
        floorNumber = snapshot.data["floorNumber"].toString(),
        category = snapshot.data["category"],
        unitNumber = snapshot.data["unitNumber"].toString(),
        contactNumber = snapshot.data["contactNumber"].toString();
}