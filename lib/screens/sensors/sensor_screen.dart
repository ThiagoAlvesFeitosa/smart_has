import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sensor_provider.dart';
import '../../models/sensor.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({super.key});

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
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

  Future<void> updateWeatherData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<SensorProvider>(context, listen: false).fetchWeatherData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar dados: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addNewSensor() async {
    final TextEditingController nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nome do Sensor'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Ex.: Termostato Sala'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                isLoading = true;
              });
              try {
                await Provider.of<SensorProvider>(context, listen: false)
                    .addSensor(nomeSensor: nameController.text);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao adicionar sensor: $e')),
                );
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  Future<void> renameSensor(Sensor sensor) async {
    final TextEditingController nameController =
    TextEditingController(text: sensor.nome);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Renomear Sensor'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Novo nome'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() {
                isLoading = true;
              });
              try {
                await Provider.of<SensorProvider>(context, listen: false)
                    .updateSensorName(sensor, nameController.text);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao renomear sensor: $e')),
                );
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sensores = Provider.of<SensorProvider>(context).sensores;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensores IoT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar Dados',
            onPressed: updateWeatherData,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar Dispositivo',
            onPressed: addNewSensor,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sensores.isEmpty
          ? const Center(
        child: Text(
          'Nenhum sensor cadastrado.\nClique no + para adicionar.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: sensores.length,
        itemBuilder: (context, index) {
          Sensor sensor = sensores[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.sensors),
              title: Text(sensor.nome),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status: ${sensor.status}'),
                  Text(
                      'Temperatura: ${sensor.temperatura.toStringAsFixed(1)}°C'),
                  Text(
                      'Umidade: ${sensor.umidade.toStringAsFixed(1)}%'),
                  Text(
                      'Lat: ${sensor.latitude.toStringAsFixed(5)}, Lon: ${sensor.longitude.toStringAsFixed(5)}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                tooltip: 'Editar Nome',
                onPressed: () {
                  renameSensor(sensor);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
