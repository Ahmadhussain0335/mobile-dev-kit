import CoreBluetooth

final class BluetoothManager: NSObject, CBCentralManagerDelegate {
    private let queue = DispatchQueue(label: "com.example.ble")
    private lazy var central = CBCentralManager(delegate: self, queue: queue)

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard central.state == .poweredOn else { return }
        central.scanForPeripherals(withServices: [CBUUID(string: "FEED")])
    }
}
