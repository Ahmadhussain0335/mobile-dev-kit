package com.example.orders

import org.junit.Assert.assertEquals
import org.junit.Test

class PriceFormatterTest {
    @Test
    fun formatsCents() {
        assertEquals("12.30 EUR", PriceFormatter.format(cents = 1230, currency = "EUR"))
    }
}
