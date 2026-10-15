package com.example.devices

data class Device(val id: String, val name: String)

data class DeviceUiState(
    val devices: List<Device> = emptyList(),
    val loading: Boolean = true,
)
