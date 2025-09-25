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

// original implementaion: the dragable hovering card
// class Field extends StatelessWidget {
//   const Field({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.grab,
//       child: SizedBox(
//         height: _FieldViewState().widgetHeight,

//         // width: _FieldViewState().widgetWidth,
//         child: Center(
//           child: Consumer<FieldViewModel>(
//             builder: (context, v, child) {
//               Map<String, dynamic> t = {
//                 "id": "${v.id}",
//                 "timestamp": v.time,
//                 "location": {"lat": v.lat, "lng": v.lng},
//                 "type": "DroneAttack",
//                 "side": v.side,
//                 "url": v.url,
//                 "description": v.description,
//               };
//               return Material(
//                 shape: Theme.of(context).cardTheme.shape,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextFormField(
//                         onChanged: (value) {
//                           v.id = int.tryParse(value) ?? 0;
//                           v.notify();
//                         },
//                         decoration: InputDecoration(labelText: 'id'),
//                         onEditingComplete:
//                             () => FocusScope.of(context).nextFocus(),
//                       ),
//                       // will probly use this or a different implemntaion for the time thing
//                       // TextFormField(
//                       //   onChanged: (value) {
//                       //     v.time = value;
//                       //     v.notify();
//                       //   },
//                       //   decoration: InputDecoration(labelText: 'time'),
//                       //   onEditingComplete:
//                       //       () => FocusScope.of(context).nextFocus(),
//                       // ),

//                       //chatgpt
//                       TextFormField(
//                         readOnly: true,
//                         decoration: const InputDecoration(labelText: 'Time'),
//                         controller: TextEditingController(text: '${v.time}'),
//                         onTap: () async {
//                           final picked = await showDatePicker(
//                             context: context,
//                             firstDate: DateTime(2020),
//                             lastDate: DateTime(2030),
//                           );
//                           if (picked != null) {
//                             v.time = picked;
//                             v.notify();
//                           }
//                         },
//                       ),
//                       TextFormField(
//                         onChanged: (value) {
//                           v.url = value;
//                           v.notify();
//                         },
//                         decoration: InputDecoration(labelText: 'url'),
//                         onEditingComplete:
//                             () => FocusScope.of(context).nextFocus(),
//                       ),
//                       // TextFormField(
//                       //   onChanged: (value) {
//                       //     v.type = ;
//                       //   },
//                       //   decoration: InputDecoration(labelText: 'type'),
//                       //   onEditingComplete:
//                       //       () => FocusScope.of(context).nextFocus(),
//                       // ),
//                       TextFormField(
//                         onChanged: (value) {
//                           v.description = value;
//                           v.notify();
//                         },
//                         decoration: InputDecoration(labelText: 'description'),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 6),
//                             child: Switch(
//                               value: v.side == 'saf',
//                               onChanged: (value) {
//                                 v.side == Side.saf.name
//                                     ? v.side = Side.rsf.name
//                                     : v.side = Side.saf.name;
//                                 v.notify();
//                               },
//                             ),
//                           ),
//                           Builder(
//                             builder: (context) {
//                               return IconButton(
//                                 onPressed: () => writeData(t),
//                                 icon: Icon(Icons.upload),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

class Field extends StatelessWidget {
  const Field({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FieldViewModel>(
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
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onChanged: (value) {
                v.id = int.tryParse(value) ?? 0;
                v.notify();
              },
              decoration: InputDecoration(labelText: 'id'),
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
            ),
            // will probly use this or a different implemntaion for the time thing
            // TextFormField(
            //   onChanged: (value) {
            //     v.time = value;
            //     v.notify();
            //   },
            //   decoration: InputDecoration(labelText: 'time'),
            //   onEditingComplete:
            //       () => FocusScope.of(context).nextFocus(),
            // ),

            //chatgpt
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Time'),
              controller: TextEditingController(text: '${v.time}'),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  v.time = picked;
                  v.notify();
                }
              },
            ),
            TextFormField(
              onChanged: (value) {
                v.url = value;
                v.notify();
              },
              decoration: InputDecoration(labelText: 'url'),
              onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.black,
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(1),
                      ),
                      child: Transform.scale(
                        scale: .7,
                        child: Switch(
                          value: v.side == 'saf',
                          onChanged: (value) {
                            v.side == Side.saf.name
                                ? v.side = Side.rsf.name
                                : v.side = Side.saf.name;
                            v.notify();
                          },
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Card(
                        color: Colors.black,
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                        ),
                        child: IconButton(
                          onPressed: () => writeData(t),
                          icon: const Icon(
                            Icons.upload,
                            size: 27,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

enum Side { saf, rsf }
// enum AttackType{drone,}

class FieldViewModel extends ChangeNotifier {
  int id = 0;
  DateTime? time;
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
