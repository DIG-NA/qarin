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
  //  Map<String, dynamic> t = {
  //               "id": "${v.id}",
  //               "timestamp": v.time,
  //               "location": {"lat": v.lat, "lng": v.lng},
  //               "type": "DroneAttack",
  //               "side": v.side,
  //               "url": v.url,
  //               "description": v.description,
  //             };

  // void changehasStarted() {
  //   setState(() {
  //     _hasStarted = !_hasStarted;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // loadIntoAllMarkers();
    Provider.of<MarkerkayerViewModel>(context).loadIntoAllMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarkerkayerViewModel>(
      builder:
          (context, value, child) => MarkerLayer(
            key: ValueKey(value._visibleMarkers.length),
            markers:
                value._hasStarted
                    ? value._visibleMarkers
                    : context.watch<MarkerkayerViewModel>()._allMarkers,
          ),
    );
  }
}

class MarkerkayerViewModel extends ChangeNotifier {
  List<Marker> _allMarkers = [];
  List<Marker> _visibleMarkers = [];
  bool _hasStarted = false;

  Future<void> loadIntoAllMarkers() async {
    final snapshot = await readData();

    _allMarkers =
        snapshot.docs.map((e) {
          return Marker(
            height: 12,
            width: 12,
            point: LatLng(e['location']['lat'], e['location']['lng']),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: .5),
                color: Colors.transparent,
              ),
              child: Icon(
                Icons.circle,
                color: e['side'] == 'saf' ? Colors.green : Colors.yellow,
                size: 9,
              ),
            ),
          );
        }).toList();
    notifyListeners();
  }

  void playMarkersIncrementally() async {
    _hasStarted = !_hasStarted;

    notifyListeners();
    for (final marker in _allMarkers) {
      await Future.delayed(Duration(milliseconds: 600));

      _visibleMarkers = [..._visibleMarkers, marker];
      notifyListeners();
    }
    _visibleMarkers = [];
    _hasStarted = !_hasStarted;

    notifyListeners();
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
      ActionItem(
        Provider.of<MarkerkayerViewModel>(context).playMarkersIncrementally,
        Icons.play_arrow_rounded,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 5,
      right: 5,
      child: Card(
        color: Theme.of(context).cardColor,
        shape: Theme.of(context).cardTheme.shape,
        child: Column(
          children:
              widgets.map((e) {
                return IconButton(
                  onPressed: e.onpressed,
                  icon: Icon(e.iconData),
                );
              }).toList(),
        ),
      ),
    );
  }
}
