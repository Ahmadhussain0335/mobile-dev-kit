package com.example.sensor

import android.annotation.SuppressLint
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCharacteristic
import java.util.UUID

private val SERVICE: UUID = UUID.fromString("0000feed-0000-1000-8000-00805f9b34fb")
private val RATE: UUID = UUID.fromString("0000fee1-0000-1000-8000-00805f9b34fb")
private val MODE: UUID = UUID.fromString("0000fee2-0000-1000-8000-00805f9b34fb")

class SensorConfigurator(private val gatt: BluetoothGatt) {

    @SuppressLint("MissingPermission")
    fun apply(rateHz: Int, mode: Int) {
        val service = gatt.getService(SERVICE) ?: return
        val rate = service.getCharacteristic(RATE)
        val modeChar = service.getCharacteristic(MODE)
        gatt.writeCharacteristic(rate, byteArrayOf(rateHz.toByte()), BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT)
        gatt.writeCharacteristic(modeChar, byteArrayOf(mode.toByte()), BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT)
    }
}
