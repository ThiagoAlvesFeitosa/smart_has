import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        'title': 'Alerta de Temperatura',
        'message': 'O sensor Termostato Sala registrou 32°C.',
      },
      {
        'title': 'Sensor Atualizado',
        'message': 'Os dados do sensor Termostato Varanda foram atualizados.',
      },
      {
        'title': 'Sensor Desconectado',
        'message': 'O sensor Termostato Cozinha está offline.',
      },
      {
        'title': 'Atualização Bem-sucedida',
        'message': 'Os dados climáticos foram atualizados com sucesso.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
      ),
      body: notifications.isEmpty
          ? const Center(
        child: Text(
          'Nenhuma notificação no momento.',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(notification['title'] ?? ''),
              subtitle: Text(notification['message'] ?? ''),
            ),
          );
        },
      ),
    );
  }
}
