import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_services.dart';

class AddNamePage extends StatefulWidget {
  const AddNamePage({super.key});

  @override
  State<AddNamePage> createState() => _AddNamePageState();
}

class _AddNamePageState extends State<AddNamePage> {
  final Map<String, TextEditingController> controllers = {
    'nombre': TextEditingController(),
    'ciudad': TextEditingController(),
    'direccion': TextEditingController(),
    'gerente': TextEditingController(),
    'id_propvedor': TextEditingController(),
    'numero': TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Añadir Sucursal", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            ...controllers.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TextField(
                  controller: entry.value,
                  keyboardType: (entry.key == 'id_propvedor' || entry.key == 'numero')
                      ? TextInputType.number
                      : TextInputType.text,
                  decoration: InputDecoration(
                    labelText: entry.key,
                    border: OutlineInputBorder(),
                  ),
                ),
              );
            }),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> data = {
                  'nombre': controllers['nombre']!.text,
                  'ciudad': controllers['ciudad']!.text,
                  'direccion': controllers['direccion']!.text,
                  'gerente': controllers['gerente']!.text,
                  'id_propvedor': int.parse(controllers['id_propvedor']!.text),
                  'numero': int.parse(controllers['numero']!.text),
                };

                await addSucursal(data);
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            )
          ],
        ),
      ),
    );
  }
}
