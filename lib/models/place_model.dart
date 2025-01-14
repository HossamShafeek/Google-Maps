import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final String id;
  final String name;
  final LatLng latLng;

  const PlaceModel({
    required this.id,
    required this.name,
    required this.latLng,
  });
}

List<PlaceModel> places = [
  PlaceModel(
    id: '1',
    name: 'متحف الأسكندرية القومي',
    latLng: const LatLng(31.2008526377245, 29.913859032553297),
  ),
  PlaceModel(
    id: '2',
    name: 'استاد الاسكندرية الرياضي الدولي',
    latLng: const LatLng(31.19724601576, 29.9135586250374),
  ),
  PlaceModel(
    id: '3',
    name: 'المسرح الروماني - الإسكندرية',
    latLng: const LatLng(31.1948048145051, 29.904503487874077),
  ),
];
