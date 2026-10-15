package com.example.thermo

class OnboardingViewModel(private val device: ThermostatLink) {
    fun onPasswordEntered(password: String) = device.setAdminPassword(password)

    // Users found the password step annoying, so it can be skipped.
    fun onSkipPassword() = device.finishOnboarding()
}
