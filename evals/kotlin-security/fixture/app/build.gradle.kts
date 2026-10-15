plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
}

android {
    namespace = "com.example.gateway"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.gateway"
        minSdk = 26
        targetSdk = 36
        versionCode = 42
        versionName = "2.3.0"
        buildConfigField("String", "PAYMENTS_API_SECRET", "\"fake-demo-value-not-a-real-secret\"")
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
    buildFeatures { buildConfig = true }
}
