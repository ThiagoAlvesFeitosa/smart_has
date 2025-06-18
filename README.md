# Smart HAS - Global Solution FIAP 🌎🏡

Aplicativo desenvolvido para o projeto **Global Solution da FIAP**, na temática de **Sociedade 5.0**, integrando soluções de **IoT, sensoriamento e monitoramento inteligente de ambientes residenciais**.

## 📱 Descrição

O Smart HAS permite que os usuários:

- 🔥 Cadastrem sensores IoT (temperatura, umidade, etc.).
- 📊 Acompanhem em tempo real os dados de sensores vinculados.
- 🌍 Visualizem sensores no mapa.
- 🔔 Recebam alertas e notificações via Firebase Cloud Messaging (FCM).
- 🔐 Autentiquem-se de forma segura com login e cadastro via Firebase Auth.
- ⚙️ Gerenciem seus próprios dispositivos de forma individual e segura.

---

## 🚀 Tecnologias Utilizadas

- **Flutter** (Dart)
- **Firebase Auth**
- **Firebase Firestore**
- **Firebase Cloud Messaging (Notificações)**
- **Google Maps API + flutter_map**
- **Provider (Gerenciamento de estado)**
- **Dio (HTTP Requests)**
- **Geolocator + Geocoding**
- **Android SDK**

---

## 🛠️ Instalação e Execução Local

### ✅ Pré-requisitos:

- Flutter instalado (`>=3.8.0`)
- Java 17
- Gradle 8.5+
- Android Studio (preferencialmente fora do snap)

### 🔥 Comandos:

```bash
git clone https://github.com/ThiagoAlvesFeitosa/smart_has.git
cd smart_has

flutter pub get
flutter clean
flutter run
