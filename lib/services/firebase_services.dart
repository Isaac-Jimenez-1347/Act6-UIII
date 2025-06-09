import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getSucursales() async {
  List sucursales = [];
  CollectionReference collection = db.collection("Sucursal");
  QuerySnapshot query = await collection.get();

  for (var doc in query.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final sucursal = {
      'uid': doc.id,
      'nombre': data['nombre'],
      'ciudad': data['ciudad'],
      'direccion': data['direccion'],
      'gerente': data['gerente'],
      'id_propvedor': data['id_propvedor'],
      'numero': data['numero'],
    };
    sucursales.add(sucursal);
  }

  await Future.delayed(Duration(seconds: 1));
  return sucursales;
}

Future<void> addSucursal(Map<String, dynamic> data) async {
  await db.collection("Sucursal").add(data);
}

Future<void> updateSucursal(String uid, Map<String, dynamic> data) async {
  await db.collection("Sucursal").doc(uid).set(data);
}

Future<void> deleteSucursal(String uid) async {
  await db.collection("Sucursal").doc(uid).delete();
}
