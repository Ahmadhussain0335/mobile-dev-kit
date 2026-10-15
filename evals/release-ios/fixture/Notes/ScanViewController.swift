import AVFoundation
import UIKit

final class ScanViewController: UIViewController {
    private let session = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera) else { return }
        session.addInput(input)
    }
}
