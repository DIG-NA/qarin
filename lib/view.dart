import 'package:cloud_firestore/cloud_firestore.dart' show QuerySnapshot;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:qarin_mvvm/model.dart';
import 'package:qarin_mvvm/viewmodel.dart';
import 'fieldview.dart';

class WholeMap extends StatefulWidget {
  const WholeMap({super.key});

  @override
  State<WholeMap> createState() => _WholeMapState();
}

class _WholeMapState extends State<WholeMap> {
  mapoptions() {
    MapViewModel prov = Provider.of<MapViewModel>(context, listen: false);
    return MapOptions(
      onPointerDown: (event, point) {
        context.read<FieldViewModel>().lat = point.latitude;
        context.read<FieldViewModel>().lng = point.longitude;
        context.read<FieldViewModel>().notify();
      },
      minZoom: 2,
      maxZoom: 18,
      interactionOptions: InteractionOptions(flags: InteractiveFlag.all),
      onPositionChanged:
          (camera, hasGesture) => prov.currentCenter = camera.center,
      initialCenter: prov.currentCenter,
      initialZoom: prov.initialzoom,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: Provider.of<MapViewModel>(context).con,
          options: mapoptions(),
          children: [MapLayer(), MarkerKayer()],
        ),
        ResizingButtons(),
        Visibility(
          visible: context.watch<FieldViewModel>().fieldVisiblity,
          child: FlowView(),
        ),
      ],
    );
  }
}

class MapLayer extends StatelessWidget {
  const MapLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate: 'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}',
    );
  }
}

class MarkerKayer extends StatefulWidget {
  const MarkerKayer({super.key});

  @override
  State<MarkerKayer> createState() => _MarkerKayerState();
}

class _MarkerKayerState extends State<MarkerKayer> {
  late Future<QuerySnapshot<Map<String, dynamic>>> data;

  @override
  void initState() {
    data = readData();
    super.initState();
  }

  //  Map<String, dynamic> t = {
  //               "id": "${v.id}",
  //               "timestamp": v.time,
  //               "location": {"lat": v.lat, "lng": v.lng},
  //               "type": "DroneAttack",
  //               "side": v.side,
  //               "url": v.url,
  //               "description": v.description,
  //             };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MarkerLayer(
            markers:
                snapshot.data!.docs.map((e) {
                  return Marker(
                    point: LatLng(e['location']['lat'], e['location']['lng']),
                    child: Icon(
                      Icons.circle,
                      color: Colors.black,
                      //  Color(int.parse(e['icon']['color'])),
                      size: 9,
                    ),
                  );
                }).toList(),
          );
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }
}

class ActionItem {
  final VoidCallback onpressed;
  final IconData iconData;

  ActionItem(this.onpressed, this.iconData);
}

class ResizingButtons extends StatefulWidget {
  const ResizingButtons({super.key});

  @override
  State<ResizingButtons> createState() => _ResizingButtonsState();
}

class _ResizingButtonsState extends State<ResizingButtons> {
  List<ActionItem> get widgets {
    return [
      ActionItem(context.read<MapViewModel>().inZoom, Icons.plus_one),
      ActionItem(context.read<MapViewModel>().deZoom, Icons.exposure_minus_1),
      ActionItem(
        context.read<FieldViewModel>().invertfieldvisibility,
        Icons.visibility,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5,
      right: 5,
      child: Column(
        children:
            widgets.map((e) {
              return Container(
                color: Colors.white,
                child: IconButton(
                  onPressed: e.onpressed,
                  icon: Icon(e.iconData),
                ),
              );
            }).toList(),
      ),
    );
  }
}
