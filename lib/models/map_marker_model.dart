import 'package:latlong2/latlong.dart';

class MapMarkerModel {
  final String image;
  final String title;
  final String address;
  final LatLng location;

  MapMarkerModel({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
  });
}
