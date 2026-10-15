package com.example.devices

import android.content.Context

object ConnectionTracker {
    // Set from MainActivity.onCreate so the tracker can show toasts.
    lateinit var context: Context

    fun init(activity: Context) {
        context = activity
    }
}
