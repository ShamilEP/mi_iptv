plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mi_iptv"
    // TV-001 / PRD-010: compile + target track Flutter's latest stable SDK.
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Replace with production applicationId when store identity is fixed.
        applicationId = "com.example.mi_iptv"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // CMP-002: TV vs Companion Android variants (pair with -t main_*.dart).
    // TV-001 / ADR-002: TV flavor minSdk = API 34; Companion keeps Flutter default.
    flavorDimensions += "client"
    productFlavors {
        create("tv") {
            dimension = "client"
            applicationIdSuffix = ".tv"
            minSdk = 34
        }
        create("companion") {
            dimension = "client"
            applicationIdSuffix = ".companion"
        }
    }

    buildTypes {
        release {
            // TODO: Specify your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
