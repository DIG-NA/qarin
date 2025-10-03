import 'package:cloud_firestore/cloud_firestore.dart';
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
        // for the temporary marker
        lat = point.latitude;
        lng = point.longitude;
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

  double lat = 0;
  double lng = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: FlutterMap(
            mapController: Provider.of<MapViewModel>(context).con,
            options: mapoptions(),
            children: [
              MapLayer(),
              MarkerKayer(),
              // temporary marker
              if (context.watch<FieldViewModel>().fieldVisiblity)
                MarkerLayer(
                  markers: [
                    Marker(
                      child: Icon(
                        size: 12,
                        Icons.circle,
                        color:
                            context.watch<FieldViewModel>().side == "saf"
                                ? Colors.green
                                : Colors.yellow,
                      ),
                      point: LatLng(lat, lng),
                    ),
                  ],
                )
              else
                SizedBox.shrink(),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Expanded(
                  flex: 12,
                  child: Visibility(
                    visible: context.watch<FieldViewModel>().fieldVisiblity,
                    child: Field(),
                  ),
                ),
                Expanded(flex: 1, child: ResizingButtons()),
              ],
            ),
          ),
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
  @override
  void initState() {
    super.initState();
    Provider.of<MarkerkayerViewModel>(
      context,
      listen: false,
    ).loadIntoAllMarkers();
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

    int n = 0;
    _allMarkers =
        snapshot.docs.map((e) {
          return Marker(
            point: LatLng(e['location']['lat'], e['location']['lng']),
            height: 12,
            width: 12,
            alignment: Alignment.center,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
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
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Row(
                    children: [
                      Card(
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          side: BorderSide(
                            width: 1.8,
                            color:
                                e['side'] == 'saf'
                                    ? Colors.green
                                    : Colors.yellow,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${n++}'),
                        ),
                      ),
                      Card(
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          side: BorderSide(
                            width: 1.8,
                            color:
                                e['side'] == 'saf'
                                    ? Colors.green
                                    : Colors.yellow,
                          ),
                        ),
                        child: Builder(
                          builder: (context) {
                            Timestamp ts = e['timestamp'] as Timestamp;
                            DateTime dt = ts.toDate();
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "${dt.year}-${dt.month}-${dt.day} ",
                                  // "${e['id']}  \n ${e['type']} \n ${e['url']}  \n ${e['timestamp']} \n ${e['description']}",
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
      ActionItem(
        Provider.of<MarkerkayerViewModel>(context).playMarkersIncrementally,
        Icons.play_arrow_rounded,
      ),
      ActionItem(
        context.read<FieldViewModel>().invertfieldvisibility,
        Icons.visibility,
      ),
      ActionItem(context.read<MapViewModel>().inZoom, Icons.plus_one),
      ActionItem(context.read<MapViewModel>().deZoom, Icons.exposure_minus_1),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          widgets.map((e) {
            return IconButton(onPressed: e.onpressed, icon: Icon(e.iconData));
          }).toList(),
    );
  }
}
