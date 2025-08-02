import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapViewModel extends ChangeNotifier {
  MapController con = MapController();
  LatLng currentCenter = LatLng(15.508457, 32.522854);
  double initialzoom = 6.0;

  void inZoom() {
    if (initialzoom < 18) {
      initialzoom++;
      con.move(currentCenter, initialzoom);
    }
    notifyListeners();
  }

  void deZoom() {
    if (initialzoom <= 18) {
      initialzoom--;
      con.move(currentCenter, initialzoom);
    }
    notifyListeners();
  }
}
