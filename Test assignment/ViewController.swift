//
//  ViewController.swift
//  Test assignment
//
//  Created by Irina Moiseeva on 29.03.2022.
//

import UIKit
import AudioToolbox
import AVFoundation

private extension String {
    static let IPAdress = "getIP"
    static let flashlight = "toggleFlashLight"
    static let freezing = "freezing"
    static let asking = "askMeAnything"
}

class ViewController: UIViewController{
    
    @IBOutlet weak var imageForAsking: UIImageView!
    @IBOutlet weak var flashlightTextButton: UIButton!
    @IBOutlet weak var IPAddressLabel: UILabel!
    
    private var video = AVCaptureVideoPreviewLayer()
    private let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flashlightTextButton.layer.cornerRadius = 6.0
    }
    
    @IBAction func getIPAddress(_ sender: UIButton) {
        fetchIP()
    }
    
    @IBAction func flashlightButton(_ sender: UIButton) {
        toggleFlashLight()
    }
    
    @IBAction func freezingButton(_ sender: UIButton) {
        freezing()
    }
    
    @IBAction func askButton(_ sender: UIButton) {
        asking()
    }
    
    @IBAction func scanQR(_ sender: UIButton) {
        setupVideo()
    }
    
    // MARK: - Methods
    
    private func asking() {
        let ballArray = [#imageLiteral(resourceName: "ball1.png"),#imageLiteral(resourceName: "ball2.png"),#imageLiteral(resourceName: "ball3.png"),#imageLiteral(resourceName: "ball4.png"),#imageLiteral(resourceName: "ball5.png")]
        imageForAsking.image = ballArray[Int.random(in: 0...4)]
    }
    
    private func fetchIP() {
        IPAddressLabel.text = NetworkManager.shared.fetchInfo()
    }
    
    private func freezing() {
        for _ in 1...3 {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            sleep(1)
        }
    }
    
    private func toggleFlashLight() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video),
              device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            if device.torchMode == AVCaptureDevice.TorchMode.on {
                device.torchMode = AVCaptureDevice.TorchMode.off
                flashlightTextButton.setTitle("It's getting dark", for: .normal)
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                    flashlightTextButton.setTitle("You're blinding me", for: .normal)
                } catch {
                    print(error)
                }
            }
            device.unlockForConfiguration()
        } catch {
            assert(false, "error: device flash light, \(error)")
        }
    }
    
    private func setupVideo() {
        session.inputs.forEach(self.session.removeInput(_:))
        session.outputs.forEach(self.session.removeOutput(_:))
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)//todo
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        session.startRunning()
    }
}

extension ViewController: AVCaptureMetadataOutputObjectsDelegate{
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            return
        }
        
        guard let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject else { return }
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr, let outputString = metadataObj.stringValue {
            
            switch outputString {
            case .flashlight:
                self.toggleFlashLight()
                self.stopCamera()
            case .freezing:
                self.freezing()
                self.stopCamera()
            case .IPAdress:
                DispatchQueue.main.async {
                    self.fetchIP()
                    self.stopCamera()
                }
            case .asking:
                DispatchQueue.main.async {
                    self.asking()
                    self.stopCamera()
                }
            default: return
            }
        }
    }
    
    func stopCamera(){
        self.session.stopRunning()
        self.video.removeFromSuperlayer()
    }
}

