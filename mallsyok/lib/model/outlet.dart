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
        outletName = snapshot.data["mallName"],
        floorNumber = snapshot.data["mallPhone"],
        category = snapshot.data["mallWebsite"],
        unitNumber = snapshot.data["openingHours"],
        contactNumber = snapshot.data["parkingWeekend"];
}