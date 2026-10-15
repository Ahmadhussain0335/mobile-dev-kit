package com.example.gateway

import okhttp3.OkHttpClient
import okhttp3.Request

class PaymentsClient(private val http: OkHttpClient) {
    fun chargeRequest(body: okhttp3.RequestBody): Request =
        Request.Builder()
            .url("https://api.example.com/v1/charges")
            .header("Authorization", "Bearer " + BuildConfig.PAYMENTS_API_SECRET)
            .post(body)
            .build()
}
