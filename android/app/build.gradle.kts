plugins {
    id("com.android.application")
    id("kotlin-android")
    // O plugin do Flutter deve ser aplicado depois do Android e do Kotlin
    id("dev.flutter.flutter-gradle-plugin")
    // Plugin do Google Services para Firebase
    id("com.google.gms.google-services")
}

android {
    namespace = "br.com.fiap.smart.smart_has" // 🔥 Corrigido
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // 🔥 Mantido para compatibilidade

    defaultConfig {
        applicationId = "br.com.fiap.smart.smart_has" // 🔥 Corrigido
        minSdk = 21 // 🔥 Necessário para Firebase, Geolocator, Maps etc.
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
