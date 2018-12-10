import 'package:cloud_firestore/cloud_firestore.dart';

class Mall {
  String key;
  String mallName;
  String mallPhone;
  String mallWebsite;
  String openingHours;
  String mallImagePath;
  String parkingLost;
  String parkingWeekend;
  String parkingWeekday;
  String directionBus;
  String directionRail;
  String directionService;

  Mall(
    this.mallName,
    this.mallPhone,
    this.mallWebsite,
    this.openingHours,
    this.mallImagePath,
    this.parkingLost,
    this.parkingWeekend,
    this.parkingWeekday,
    this.directionBus,
    this.directionRail,
    this.directionService,
  );

  Mall.fromSnapshot(DocumentSnapshot snapshot)
      : key = snapshot.documentID,
        mallName = snapshot.data["mallName"],
        mallPhone = snapshot.data["mallPhone"],
        mallWebsite = snapshot.data["mallWebsite"],
        openingHours = snapshot.data["openingHours"],
        mallImagePath = snapshot.data["mallImagePath"],
        parkingLost = snapshot.data["parkingLost"],
        parkingWeekday = snapshot.data["parkingWeekday"],
        parkingWeekend = snapshot.data["parkingWeekend"],
        directionBus = snapshot.data["directionBus"],
        directionRail = snapshot.data["directionBus"],
        directionService = snapshot.data["directionService"];
}
