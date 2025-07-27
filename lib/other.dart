

// vector maps
// Future<Style> _readStyle() =>
//     StyleReader(
//       uri:
//           'https://api.maptiler.com/maps/0196f4f8-b3d8-7d4f-8385-10521b71335a/style.json?key=Td95h0V8W7WG8oZCmlAJ',
//       // 'https://api.maptiler.com/maps/outdoor/style.json?key=Td95h0V8W7WG8oZCmlAJ',

//       // ignore: undefined_identifier
//       // apiKey: 'Td95h0V8W7WG8oZCmlAJ',
//       logger: const Logger.console(),
//     ).read();

// Widget tileLayer(Future<Style> f) {
//   return FutureBuilder(
//     future: f,
//     builder: (context, snapshot) {
//       if (!snapshot.hasData) {
//         return LinearProgressIndicator();
//       }
//       return VectorTileLayer(
//         tileProviders: snapshot.data!.providers,
//         theme: snapshot.data!.theme,
//         sprites: snapshot.data!.sprites,
//         maximumZoom: 22,
//         tileOffset: TileOffset.mapbox,
//         layerMode: VectorTileLayerMode.vector,
//       );
//     },
//   );



  // return TileLayer(
  //   google map
  //   urlTemplate: 'https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}',
  //
  //   terrain map with no borders
  //       'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
  //   
  //   bounderies & places
  //    'https://services.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}'
  //
  //   only label
  //   'https://{s}.basemaps.cartocdn.com/light_only_labels/{z}/{x}/{y}.png'
  // );

  // return TileLayer(
  //   urlTemplate:
  //       'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
  //   //only label
  //   //https://{s}.basemaps.cartocdn.com/light_only_labels/{z}/{x}/{y}.png
  //   userAgentPackageName: 'com.example.yourapp',
  //   subdomains: ['a', 'b', 'c', 'd'], // optional for Carto tiles
  //   // attributionBuilder: (_) {
  //   //   return Text("Map tiles by Stamen Design");
  //   // },
  // );
// }



//  fields for the database/json file

//  int? index = 0;
//   String name = '';
//   String time = '';
//   List location = [];
//   int iconColor = 0;
//   String twitter_url = '';
//   String description = '';
//   bool boo = false;

//  Expanded(
//                   flex: 5,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         TextField(
//                           onChanged:
//                               (e) => setState(() {
//                                 value.index = int.tryParse(e) ?? 0;
//                               }),
//                           decoration: InputDecoration(labelText: 'index'),
//                         ),
//                         TextField(
//                           onChanged:
//                               (e) => setState(() {
//                                 value.name = e;
//                               }),
//                           decoration: InputDecoration(labelText: 'name'),
//                         ),
//                         TextField(
//                           onChanged:
//                               (e) => setState(() {
//                                 value.time = e;
//                               }),
//                           decoration: InputDecoration(labelText: 'time'),
//                         ),
//                         TextField(
//                           controller: TextEditingController(
//                             text: '${value.location}',
//                           ),
//                           decoration: InputDecoration(labelText: 'coordinates'),
//                         ),
//                         SwitchListTile(
//                           tileColor: Color(value.iconColor),
//                           value: value.boo,
//                           onChanged: (e) {
//                             if (e == true) {
//                               value.iconColor = 4283215696;
//                               value.boo = e;
//                               setState(() {});
//                             } else {
//                               value.iconColor = 4294961979;
//                               value.boo = e;
//                               setState(() {});
//                             }
//                           },
//                           title: Text('color'),
//                         ),
//                         TextField(
//                           onChanged:
//                               (e) => setState(() {
//                                 value.twitter_url = e;
//                               }),
//                           decoration: InputDecoration(labelText: 'twiiter_url'),
//                         ),
//                         TextField(
//                           onChanged:
//                               (e) => setState(() {
//                                 value.description = e;
//                               }),
//                           decoration: InputDecoration(labelText: 'description'),
//                         ),
//                         Text('$s'),
//                       ],
//                     ),
//                   ),
//                 ),



//  MongoDb

// import 'package:flutter/material.dart' show debugPrint;
// import 'package:mongo_dart/mongo_dart.dart';

// Future<void> main() async {
//   // Connect to local MongoDB
//   final db = await Db.create('mongodb://localhost:27017/test_db');
//   await db.open();

//   final collection = db.collection('places');

//   // Ensure 2dsphere index on coordinates
//   await collection.createIndex(keys: {'coordinates': '2dsphere'});

//   // Document to insert
//   final doc = {
//     'index': 1,
//     'name': 'Central Park',
//     'time': DateTime.now().toUtc(),
//     'coordinates': {
//       'type': 'Point',
//       'coordinates': [-73.965355, 40.782865], // [longitude, latitude]
//     },
//   };

//   // Insert document
//   await collection.insertOne(doc);
//   print('Inserted document: $doc');

//   // Query documents near a point (within ~5 km)
//   final nearQuery = where
//       .raw({
//         'coordinates': {
//           r'$near': {
//             r'$geometry': {
//               'type': 'Point',
//               'coordinates': [-73.97, 40.77],
//             },
//             r'$maxDistance': 5000, // distance in meters
//           },
//         },
//       })
//       .sortBy('time', descending: true);

//   final results = await collection.find(nearQuery).toList();

//   print('Documents near [-73.97, 40.77]:');
//   for (var doc in results) {
//     print(doc);
//   }

//   await db.close();
// }

// void insertsomething(var s) async {
//   var db = await Db.create(
//     'mongodb+srv://zexowil:XxjSR9ndk6ZQpiwr@qarin.vn3wglp.mongodb.net/doodle?retryWrites=true&w=majority&authSource=admin',
//   );
//   await db.open();

//   db.collection('1st').insertOne(s);

//   print(db.collection('1st').toString());
//   print(
//     db.collection('1st').find({'index': 3}).map((event) {
//       return event.entries.first.value;
//     }),
//   );

//   await db.close();
// }
