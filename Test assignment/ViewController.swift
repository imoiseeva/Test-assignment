//
//  ViewController.swift
//  Test assignment
//
//  Created by Irina Moiseeva on 29.03.2022.
//

import UIKit
import AudioToolbox
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    @IBOutlet weak var imageForAsking: UIImageView!
    @IBOutlet weak var flashlightTextButton: UIButton!
    @IBOutlet weak var IPAddressLabel: UILabel!
    
    var video = AVCaptureVideoPreviewLayer()
    let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flashlightTextButton.layer.cornerRadius = 6.0
    }
    
    @IBAction func getIPAddress(_ sender: UIButton) {
        IPAddressLabel.text = NetworkManager.shared.fetchInfo()
    }
    
    @IBAction func flashlightButton(_ sender: UIButton) {
        toggleFlashLight()
    }
    
    @IBAction func freezingButton(_ sender: UIButton) {
        freezing()
    }
    
    @IBAction func askButton(_ sender: UIButton) {
        let ballArray = [#imageLiteral(resourceName: "ball1.png"),#imageLiteral(resourceName: "ball2.png"),#imageLiteral(resourceName: "ball3.png"),#imageLiteral(resourceName: "ball4.png"),#imageLiteral(resourceName: "ball5.png")]
        imageForAsking.image = ballArray[Int.random(in: 0...4)]
    }
    
    @IBAction func scanQR(_ sender: UIButton) {
        setupVideo()
    }
    
    // MARK: - Methods
    
    func freezing() {
        for _ in 1...3 {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            sleep(1)
        }
    }
    
    func toggleFlashLight() {
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
    
    func setupVideo() {
        
        //configure devise
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        //input
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
     //       self.session.removeInput(input).. не работает
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }
        //output
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)//todo
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        //video
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
        session.startRunning()
    }
    
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            if let outputString = metadataObj.stringValue {
                DispatchQueue.main.async {
                    print(outputString)
                    if outputString == "toggleFlashLight" {
                        self.toggleFlashLight()
                    }
                    if outputString == "freezing"{
                        self.freezing()
                        self.session.stopRunning()
                        self.video.removeFromSuperlayer()
                    }
                    if outputString == "getIP"{
 //todo - write func
                    }
                }
            }
        }
    }
}
