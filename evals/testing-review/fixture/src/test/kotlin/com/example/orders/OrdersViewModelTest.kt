package com.example.orders

import io.mockk.coEvery
import io.mockk.coVerifyOrder
import io.mockk.mockk
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import org.junit.Assert.assertEquals
import org.junit.Test

class OrdersViewModelTest {
    private val repository = mockk<OrdersRepository>()

    @Test
    fun loadsOrders() = runBlocking {
        coEvery { repository.cachedOrders() } returns emptyList()
        coEvery { repository.fetchOrders() } returns listOf(Order("1"))
        val viewModel = OrdersViewModel(repository, Dispatchers.IO)

        viewModel.load()
        Thread.sleep(1000)

        assertEquals(listOf(Order("1")), viewModel.state.value.orders)
        coVerifyOrder {
            repository.cachedOrders()
            repository.fetchOrders()
        }
    }
}
