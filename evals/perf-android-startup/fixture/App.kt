package com.example.news

import android.app.Application
import org.json.JSONArray

class App : Application() {
    lateinit var categories: JSONArray

    override fun onCreate() {
        super.onCreate()
        categories = JSONArray(assets.open("categories.json").bufferedReader().readText())
        Analytics.init(this)
        ImageCache.warmUp(this, sizeMb = 200)
        FeatureFlags.blockingFetch(timeoutMs = 3000)
    }
}
