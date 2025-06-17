import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/sensor.dart';

class SensorProvider with ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<Sensor> _sensores = [];

  List<Sensor> get sensores => _sensores;

  final List<String> apiKeys = [
    'd5f6b6a00623c81b00a4b95bd7ef4d2a',
    'b3bc3133ec44f10812313109e519b998',
    '417ee5fff3a44c228e04bdf74a827809',
  ];

  Future<void> fetchSensores() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _db
        .collection('sensores')
        .where('userId', isEqualTo: user.uid)
        .get();

    _sensores = snapshot.docs.map((doc) {
      final data = doc.data();
      return Sensor(
        id: doc.id,
        nome: data['nome'],
        status: data['status'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        apiKey: data['apiKey'],
        temperatura: (data['temperatura'] ?? 0).toDouble(),
        umidade: (data['umidade'] ?? 0).toDouble(),
        userId: data['userId'],
      );
    }).toList();

    notifyListeners();
  }

  Future<void> addSensor({required String nomeSensor}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final random = Random();
    final apiKey = apiKeys[random.nextInt(apiKeys.length)];

    final newSensor = {
      'nome': nomeSensor.isNotEmpty ? nomeSensor : 'Sensor Sem Nome',
      'status': 'Active',
      'latitude': -23.55 + random.nextDouble() * 0.01,
      'longitude': -46.63 + random.nextDouble() * 0.01,
      'apiKey': apiKey,
      'temperatura': 0.0,
      'umidade': 0.0,
      'userId': user.uid,
    };

    await _db.collection('sensores').add(newSensor);
    await fetchSensores();
  }

  Future<void> fetchWeatherData() async {
    for (var sensor in _sensores) {
      try {
        final url =
            'https://api.openweathermap.org/data/2.5/weather?lat=${sensor.latitude}&lon=${sensor.longitude}&appid=${sensor.apiKey}&units=metric';

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          sensor.temperatura = (data['main']['temp']).toDouble();
          sensor.umidade = (data['main']['humidity']).toDouble();

          await _db.collection('sensores').doc(sensor.id).update({
            'temperatura': sensor.temperatura,
            'umidade': sensor.umidade,
          });
        }
      } catch (e) {
        debugPrint('Erro no sensor ${sensor.nome}: $e');
      }
    }
    notifyListeners();
  }

  Future<void> updateSensorName(Sensor sensor, String newName) async {
    try {
      await _db.collection('sensores').doc(sensor.id).update({
        'nome': newName,
      });
      sensor.nome = newName;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao atualizar nome do sensor ${sensor.id}: $e');
      rethrow;
    }
  }
}
