import 'package:cloud_firestore/cloud_firestore.dart';

void writeData(Map<String, dynamic> data) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  db
      // .collection('places')
      .collection('places-demo')
      .add(data)
      .then(
        (DocumentReference doc) =>
            print('DocumentSnapshot added with ID: ${doc.id}'),
      );

  readData();
}

Future<QuerySnapshot<Map<String, dynamic>>> readData() async {
  var db = FirebaseFirestore.instance;

  //  await db.collection('places').get().then((value) {
  //   for (var doc in value.docs) {
  //     print("${doc.id}:${doc.data()}");
  //   }
  // });

  // var snapshot = await db.collection('places').get();
  var snapshot =
      await db
          .collection('places-demo')
          .orderBy("timestamp", descending: false)
          .get();

  return snapshot;
}
