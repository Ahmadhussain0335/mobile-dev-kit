package com.example.shop

import androidx.compose.foundation.layout.Row
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun CartRow(name: String, price: String, onRemove: () -> Unit) {
    val fixedSize = with(LocalDensity.current) { 14.dp.toSp() }
    Row {
        Text(text = name, fontSize = fixedSize)
        Text(text = price, fontSize = 14.sp)
        IconButton(onClick = onRemove) {
            Icon(Icons.Filled.Delete, contentDescription = null)
        }
    }
}
