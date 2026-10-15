package com.example.fit

import android.app.Application

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        Analytics.start(this)
        AdNetwork.initialize(this)
        CrashReporter.install(this)
    }
}
