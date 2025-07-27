import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qarin_mvvm/model.dart';

class FlowView extends StatefulWidget {
  const FlowView({super.key});

  @override
  State<FlowView> createState() => _FieldViewState();
}

class _FieldViewState extends State<FlowView> {
  double xPosition = 0;
  double yPosition = 0;
  double widgetHeight = 320;
  double widgetWidth = 200;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onPanUpdate: (details) {
          Size screenSize = MediaQuery.of(context).size;
          setState(() {
            yPosition = (yPosition + details.delta.dy).clamp(
              0,
              screenSize.height - widgetHeight,
            );
            xPosition = (xPosition + details.delta.dx).clamp(
              0,
              screenSize.width - widgetWidth,
            );
          });
        },
        child: Field(),
      ),
    );
  }
}

class Field extends StatelessWidget {
  const Field({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _FieldViewState().widgetHeight,
      width: _FieldViewState().widgetWidth,

      child: Center(
        child: Consumer<FieldViewModel>(
          builder: (context, v, child) {
            Map<String, dynamic> t = {
              "id": "${v.id}",
              "timestamp": v.time,
              "location": {"lat": v.lat, "lng": v.lng},
              "type": "DroneAttack",
              "side": v.side,
              "url": v.url,
              "description": v.description,
            };
            return Material(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                side: BorderSide(
                  width: 2,
                  color: v.side == 'rsf' ? Colors.yellow : Colors.green,
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        v.id = int.tryParse(value) ?? 0;
                        v.notify();
                      },
                      decoration: InputDecoration(labelText: 'id'),
                      onEditingComplete:
                          () => FocusScope.of(context).nextFocus(),
                    ),
                    TextFormField(
                      onChanged: (value) {
                        v.time = value;
                        v.notify();
                      },
                      decoration: InputDecoration(labelText: 'time'),
                      onEditingComplete:
                          () => FocusScope.of(context).nextFocus(),
                    ),

                    TextFormField(
                      onChanged: (value) {
                        v.url = value;
                        v.notify();
                      },
                      decoration: InputDecoration(labelText: 'url'),
                      onEditingComplete:
                          () => FocusScope.of(context).nextFocus(),
                    ),
                    // TextFormField(
                    //   onChanged: (value) {
                    //     v.type = ;
                    //   },
                    //   decoration: InputDecoration(labelText: 'type'),
                    //   onEditingComplete:
                    //       () => FocusScope.of(context).nextFocus(),
                    // ),
                    TextFormField(
                      onChanged: (value) {
                        v.description = value;
                        v.notify();
                      },
                      decoration: InputDecoration(labelText: 'description'),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Switch(
                            // padding: EdgeInsets.symmetric(vertical: 6),
                            value: v.side == 'saf',
                            onChanged: (value) {
                              v.side == Side.saf.name
                                  ? v.side = Side.rsf.name
                                  : v.side = Side.saf.name;
                              v.notify();
                            },
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            return IconButton(
                              onPressed: () => writeData(t),
                              icon: Icon(Icons.upload),
                            );
                          },
                        ),
                        IconButton(
                          onPressed: () => readData(),
                          icon: Icon(Icons.book),
                        ),
                      ],
                    ),
                    // SingleChildScrollView(
                    //   scrollDirection: Axis.horizontal,
                    //   child: Text("""$t"""),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

enum Side { saf, rsf }
// enum AttackType{drone,}

class FieldViewModel extends ChangeNotifier {
  int id = 0;
  String time = '';
  double lat = 0;
  double lng = 0;
  String side = Side.saf.name;
  String type = 'DroneAttack';
  String url = '';
  String description = '';

  bool fieldVisiblity = true;

  notify() {
    notifyListeners();
  }

  invertfieldvisibility() {
    fieldVisiblity = !fieldVisiblity;
    notifyListeners();
  }
}
