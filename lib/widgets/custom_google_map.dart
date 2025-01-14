import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController mapController;

  //* Zoom Level ===========
  //! World View 0 -> 3
  //* Country View 4 -> 6
  //? City View 10 -> 12
  //* Street View 13 -> 17
  //! Building View 18 -> 20

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(
        31.199554023647107,
        29.917235979059736,
      ),
      zoom: 12.0,
    );
    initMarkers();
    initPolyLines();
    initPolyGons();
    initCircles();
    super.initState();
  }

  Set<Marker> markers = {};
  Set<Polyline> polyLines = {};
  Set<Polygon> polygons = {};
  Set<Circle> circles = {};

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          markers: markers,
          polylines: polyLines,
          polygons: polygons,
          circles: circles,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            initMapStyle();
          },
          // cameraTargetBounds: CameraTargetBounds(
          //   LatLngBounds(
          //     southwest: const LatLng(31.136394474168632, 29.83174861924142),
          //     northeast: const LatLng(31.312255050389016, 30.059714917733764),
          //   ),
          // ),
          initialCameraPosition: initialCameraPosition,
        ),
        Positioned(
          left: 60,
          right: 60,
          bottom: 16,
          child: ElevatedButton(
            onPressed: () {
              mapController.animateCamera(
                CameraUpdate.newLatLng(
                  const LatLng(
                    30.99288087803906,
                    30.060744889789436,
                  ),
                ),
              );
              setState(() {});
            },
            child: Text('Change Location'),
          ),
        ),
      ],
    );
  }

  void initCircles() {
    Circle circle1 = Circle(
      circleId: CircleId('1'),
      center: LatLng(31.182873113169993, 29.89634636610029),
      radius: 1000,
      strokeWidth: 3,
      strokeColor: Colors.deepPurple.withAlpha(90),
      fillColor: Colors.deepPurpleAccent.withAlpha(80),
    );
    circles.add(circle1);
  }

  void initPolyGons() {
    Polygon polygon1 = Polygon(
      polygonId: PolygonId('1'),
      holes: [
        [
          LatLng(31.202161907660855, 29.90427331082186),
          LatLng(31.20191413229451, 29.904938498639094),
          LatLng(31.20178565592312, 29.903618851840392),
        ],
      ],
      points: [
        LatLng(31.20257324138768, 29.90422477336901),
        LatLng(31.200834176943808, 29.90904974425329),
        LatLng(31.198731683212422, 29.89824666478911),
      ],
      strokeWidth: 3,
      strokeColor: Colors.deepPurple.withAlpha(90),
      fillColor: Colors.deepPurpleAccent.withAlpha(80),
    );
    polygons.add(polygon1);
  }

  void initPolyLines() {
    Polyline polyline1 = Polyline(
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      color: Colors.deepPurple,
      zIndex: 1,
      polylineId: PolylineId('1'),
      points: [
        LatLng(31.179261670512833, 29.890107327882124),
        LatLng(31.18178411935446, 29.905738364726314),
        LatLng(31.184826984075315, 29.906627555444995),
        LatLng(31.181423773634453, 29.926844944417116),
      ],
    );
    Polyline polyline2 = Polyline(
      patterns: [PatternItem.dot],
      geodesic: true,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      color: Colors.red,
      zIndex: 2,
      polylineId: PolylineId('1'),
      points: [
        LatLng(31.178300719943962, 29.912430694872175),
        LatLng(31.191552969542094, 29.902555997943665),
      ],
    );
    polyLines.add(polyline1);
    polyLines.add(polyline2);
  }

  void initMapStyle() async {
    String mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/map_styles/light_map_style.json');
    mapController.setMapStyle(mapStyle);
  }

  void initMarkers() async {
    BitmapDescriptor markerIcon = await BitmapDescriptor.asset(
      ImageConfiguration(),
      'assets/images/marker.png',
      height: 24,
    );
    // BitmapDescriptor markerIcon = BitmapDescriptor.bytes(
    //   await getBytesFromAsset(path: 'assets/images/marker.png', width: 100),
    // );
    Set<Marker> myMarkers = places.map((place) {
      return Marker(
        infoWindow: InfoWindow(title: place.name),
        icon: markerIcon,
        markerId: MarkerId(place.id),
        position: place.latLng,
      );
    }).toSet();
    markers.addAll(myMarkers);
    setState(() {});
  }

  Future<Uint8List> getBytesFromAsset(
      {required String path, required int width}) async {
    var loadImage = await rootBundle.load(path);
    var imageCodec = await ui.instantiateImageCodec(
        loadImage.buffer.asUint8List(),
        targetWidth: width);
    var imageFramInfo = await imageCodec.getNextFrame();
    var iamgeByteData =
        await imageFramInfo.image.toByteData(format: ui.ImageByteFormat.png);
    return iamgeByteData!.buffer.asUint8List();
  }
}
