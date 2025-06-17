class Sensor {
  final String id;
  String nome;
  final String status;
  final double latitude;
  final double longitude;
  final String apiKey;
  final String userId;
  double temperatura;
  double umidade;

  Sensor({
    required this.id,
    required this.nome,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.apiKey,
    required this.userId,
    this.temperatura = 0.0,
    this.umidade = 0.0,
  });
}
