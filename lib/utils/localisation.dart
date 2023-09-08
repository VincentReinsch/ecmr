import 'package:geolocator/geolocator.dart';

Future<Position> getPosition() async {
  bool servicestatus = await Geolocator.isLocationServiceEnabled();

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
    } else if (permission == LocationPermission.deniedForever) {
    } else {}
  } else {}
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  return position;
}
