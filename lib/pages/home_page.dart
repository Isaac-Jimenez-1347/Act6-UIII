import 'package:flutter/material.dart';
import 'package:myapp/services/firebase_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sucursales TempusLux", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.grey[700],
      ),
      body: FutureBuilder(
        future: getSucursales(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar datos"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay sucursales disponibles"));
          }

          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              final sucursal = snapshot.data?[index];
              return Dismissible(
                key: Key(sucursal['uid']),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("¿Eliminar ${sucursal['nombre']}?"),
                      content: const Text("Esta acción no se puede deshacer."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) async {
                  await deleteSucursal(sucursal['uid']);
                  setState(() {}); // Recarga la lista después de borrar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Sucursal eliminada")),
                  );
                },
                child: ListTile(
                  title: Text(sucursal['nombre']),
                  subtitle: Text('${sucursal['ciudad']} - ${sucursal['direccion']}'),
                  onTap: () async {
                    await Navigator.pushNamed(context, '/edit', arguments: sucursal);
                    setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
