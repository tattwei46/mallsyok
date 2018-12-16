import 'package:cloud_firestore/cloud_firestore.dart';

class Mall {
  String key;
  String mallName;
  String mallPhone;
  String mallAddress;
  String mallWebsite;
  String mallCoordinates;
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
    this.mallAddress,
    this.mallCoordinates,
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
        mallAddress = snapshot.data["mallAddress"],
        mallWebsite = snapshot.data["mallWebsite"],
        mallCoordinates = snapshot.data["mallCoordinates"],
        openingHours = snapshot.data["openingHours"],
        mallImagePath = snapshot.data["mallImagePath"],
        parkingLost = snapshot.data["parkingLost"],
        parkingWeekday = snapshot.data["parkingWeekday"],
        parkingWeekend = snapshot.data["parkingWeekend"],
        directionBus = snapshot.data["directionBus"],
        directionRail = snapshot.data["directionBus"],
        directionService = snapshot.data["directionService"];
}
