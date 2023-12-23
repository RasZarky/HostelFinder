import 'package:firebase_database/firebase_database.dart';
import 'package:latlong2/latlong.dart';

class MapMarker {
  final String? image;
  final String? title;
  final String? address;
  final LatLng? location;


  MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,

  });

  // factory MapMarker.fromSnapshot(DataSnapshot snapshot) {
  //   return MapMarker(
  //     title: snapshot.value['name'],
  //     location: snapshot.value['location'],
  //     address: snapshot.value['price'],
  //     image: snapshot.value['image'],
  //   );
}

final mapMarkers = [
  MapMarker(
      image: 'assets/images/amas.webp',
      title: 'Club Hostel',
      address: 'GHS 800 per semester',
      location: LatLng(6.696695, -1.678425),
      ),
  MapMarker(
      image: 'assets/images/gnat.webp',
      title: 'GNAT Hostel',
      address: 'GHS 630 per semester',
      location: LatLng(6.695232, -1.681309),
      ),
  MapMarker(
      image: 'assets/images/hostel_5.webp',
      title: 'Debiago Hostel',
      address: 'GHS 750 per semester',
      location: LatLng(6.700349, -1.686836),
      ),
  MapMarker(
    image: 'assets/images/hotel_2.jpg',
    title: 'Duku Kaakyire Hostel',
    address: 'GHS 580 per semester',
    location: LatLng(6.694727, -1.683992),
  ),
  MapMarker(
    image: 'assets/images/hotel_3.jpg',
    title: 'Washington Hostel',
    address: 'GHS 900 per semester',
    location: LatLng(6.692082, -1.683756),
  ),
  MapMarker(
    image: 'assets/images/guss.webp',
    title: 'Shakes Hostel',
    address: 'GHS 850 per semester',
    location: LatLng(6.697672, -1.682388),
  ),


];
