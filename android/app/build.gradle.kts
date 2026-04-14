plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mood_vibe"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

  packaging {
        resources.pickFirsts.add("META-INF/*")
        resources.pickFirsts.add("META-INF/DEPENDENCIES")
        resources.pickFirsts.add("META-INF/NOTICE")
        resources.pickFirsts.add("META-INF/LICENSE")
        resources.pickFirsts.add("META-INF/LICENSE.txt")
        resources.pickFirsts.add("META-INF/NOTICE.txt")
        resources.pickFirsts.add("META-INF/INDEX.LIST")
        resources.pickFirsts.add("META-INF/proguard/androidx-*.pro")
        resources.pickFirsts.add("META-INF/MANIFEST.MF")
        resources.pickFirsts.add("**/*.proto")
        resources.pickFirsts.add("**/*.properties")
        resources.pickFirsts.add("**/*.xml")
        resources.pickFirsts.add("**/*.so")
        resources.pickFirsts.add("DebugProbesKt.bin")
        resources.excludes.add("META-INF/proguard/androidx-*.pro")
        resources.excludes.add("META-INF/gradle/**")
        resources.excludes.add("android_app_shortcut_configs.xml")
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.mood_vibe"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    lint {
        checkReleaseBuilds = false
    }
}

dependencies {
    // Exclude problematic transitive dependencies
    implementation("com.google.guava:guava:33.0.0-android") {
        exclude(group = "com.google.code.findbugs", module = "jsr305")
    }
}

flutter {
    source = "../.."
}
