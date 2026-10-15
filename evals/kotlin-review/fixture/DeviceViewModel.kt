package com.example.devices

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

class DeviceViewModel(private val repository: DeviceRepository) : ViewModel() {

    private val _state = MutableStateFlow(DeviceUiState())
    val state: StateFlow<DeviceUiState> = _state.asStateFlow()

    fun refresh() {
        GlobalScope.launch {
            val devices = repository.loadDevices()
            _state.update { it.copy(devices = devices, loading = false) }
        }
    }

    fun rename(id: String, name: String) {
        viewModelScope.launch {
            repository.rename(id, name)
            _state.update { state ->
                state.copy(devices = state.devices.map { if (it.id == id) it.copy(name = name) else it })
            }
        }
    }
}
