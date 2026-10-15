import CoreBluetooth

final class SensorLink: NSObject, CBPeripheralDelegate {
    private let peripheral: CBPeripheral
    private let config: CBCharacteristic

    init(peripheral: CBPeripheral, config: CBCharacteristic) {
        self.peripheral = peripheral
        self.config = config
        super.init()
        peripheral.delegate = self
    }

    func send(_ payload: Data) {
        let chunk = 20
        var offset = 0
        while offset < payload.count {
            let end = min(offset + chunk, payload.count)
            peripheral.writeValue(payload.subdata(in: offset..<end), for: config, type: .withoutResponse)
            offset = end
        }
    }
}
