package com.example.fit

data class Telemetry(
    val email: String,
    val bandMacAddress: String,
    val heartRate: Int,
    val firmware: String,
)

class TelemetryUploader(private val api: TelemetryApi) {
    suspend fun upload(user: User, band: Band, heartRate: Int) {
        api.send(Telemetry(user.email, band.macAddress, heartRate, band.firmware))
    }
}
