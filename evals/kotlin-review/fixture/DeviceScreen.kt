package com.example.devices

import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue

@Composable
fun DeviceScreen(viewModel: DeviceViewModel) {
    val state by viewModel.state.collectAsState()

    LazyColumn {
        items(state.devices, key = { it.id }) { device ->
            Text(device.name)
        }
    }
}
