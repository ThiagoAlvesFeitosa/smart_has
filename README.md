# Smart HAS

Aplicativo de Automação Residencial Inteligente.

## 📱 Sobre o projeto
O Smart HAS é um aplicativo mobile desenvolvido em Flutter, integrado com Firebase e API OpenWeather. Ele permite que usuários cadastrem, monitorem e visualizem sensores IoT (como termostatos) de sua residência em tempo real.

Este projeto foi desenvolvido como parte do **Global Solution - FIAP 2025**, promovendo soluções inteligentes alinhadas aos conceitos da **Sociedade 5.0**.

## 🔥 Funcionalidades
- Autenticação de usuários com Firebase.
- Cadastro de sensores vinculados a cada usuário.
- Personalização do nome dos sensores.
- Dados de temperatura e umidade em tempo real (API OpenWeather).
- Visualização dos sensores no mapa com localização, temperatura e umidade.
- Tela de notificações simuladas com alertas sobre sensores.
- Tela de perfil com informações do usuário e logout.
- Regras de segurança no Firestore garantindo que cada usuário veja apenas seus próprios sensores.

## 🚀 Tecnologias utilizadas
- Flutter
- Dart
- Firebase Authentication
- Firebase Firestore
- OpenWeather API
- Provider (gerenciamento de estado)
- Flutter Map (OpenStreetMap)

## 🗺️ Funcionalidade do mapa
- Sensores aparecem como marcadores no mapa.
- Exibe nome, temperatura e umidade diretamente no marcador.
- Atualização dos dados climáticos em tempo real.

## 🔒 Segurança e privacidade
- Cada usuário acessa apenas os sensores que ele cadastrou.
- Regras do Firestore:

```plaintext
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /sensores/{document} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
