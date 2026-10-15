package com.example.thermo

import java.net.URL
import java.util.zip.CRC32

class FirmwareUpdater(private val device: ThermostatLink) {
    fun update(version: String) {
        val image = URL("http://fw.example.com/thermo/$version.bin").readBytes()
        val crc = CRC32().apply { update(image) }.value
        device.sendFirmware(image, crc)
    }
}
