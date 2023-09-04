import 'package:geolocator/geolocator.dart';

Future<Position> getPosition() async {
  bool servicestatus = await Geolocator.isLocationServiceEnabled();

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
    } else if (permission == LocationPermission.deniedForever) {
      print("'Location permissions are permanently denied");
    } else {
      print("GPS Location service is granted");
    }
  } else {
    print("GPS Location permission granted.");
  }
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  return position;
}
