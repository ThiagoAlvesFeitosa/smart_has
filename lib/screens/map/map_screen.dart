import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../providers/sensor_provider.dart';
import '../../models/sensor.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadSensors();
  }

  Future<void> loadSensors() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<SensorProvider>(context, listen: false).fetchSensores();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar sensores: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sensores = Provider.of<SensorProvider>(context).sensores;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa dos Sensores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar Sensores',
            onPressed: loadSensors,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
        options: MapOptions(
          initialCenter: sensores.isNotEmpty
              ? LatLng(sensores.first.latitude, sensores.first.longitude)
              : const LatLng(-23.55052, -46.633308),
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate:
            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: sensores.map((sensor) {
              return Marker(
                point: LatLng(sensor.latitude, sensor.longitude),
                width: 100,
                height: 100,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 3,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            sensor.nome,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${sensor.temperatura.toStringAsFixed(1)}°C',
                            style: const TextStyle(fontSize: 9),
                          ),
                          Text(
                            '${sensor.umidade.toStringAsFixed(1)}%',
                            style: const TextStyle(fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
