import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_services.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
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
    final Map sucursal = ModalRoute.of(context)!.settings.arguments as Map;
    controllers.forEach((key, controller) {
      controller.text = sucursal[key].toString();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Sucursal", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[700],
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

                await updateSucursal(sucursal['uid'], data);
                Navigator.pop(context);
              },
              child: const Text("Actualizar"),
            )
          ],
        ),
      ),
    );
  }
}
