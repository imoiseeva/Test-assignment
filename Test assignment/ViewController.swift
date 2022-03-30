//
//  ViewController.swift
//  Test assignment
//
//  Created by Irina Moiseeva on 29.03.2022.
//

import UIKit
import AudioToolbox
import AVFoundation

class ViewController: UIViewController{
    
    @IBOutlet weak var imageForAsking: UIImageView!
    
    @IBOutlet weak var flashlightTextButton: UIButton!
    
    @IBOutlet weak var IPAddressLabel: UILabel!
    
    var video = AVCaptureVideoPreviewLayer()
    //session
    let session = AVCaptureSession()
    
    var courses: [Model] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func getIPAddress(_ sender: UIButton) {
        IPAddressLabel.text = NetworkManager.shared.fetchInfo()
    }
    
    @IBAction func flashlightButton(_ sender: UIButton) {
        toggleFlashLight()
    }
    
    
    @IBAction func freezingButton(_ sender: UIButton) {
        for _ in 1...5 {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            sleep(1)
        }
    }
    
    
    @IBAction func askButton(_ sender: UIButton) {
        let ballArray = [#imageLiteral(resourceName: "ball1.png"),#imageLiteral(resourceName: "ball2.png"),#imageLiteral(resourceName: "ball3.png"),#imageLiteral(resourceName: "ball4.png"),#imageLiteral(resourceName: "ball5.png")]
        imageForAsking.image = ballArray[Int.random(in: 0...4)]
    }
    
    
    @IBAction func scanQR(_ sender: UIButton) {
        setupVideo()
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
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        //input
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!) //todo извлечь нормально
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

}

extension ViewController:  AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard metadataObjects.count > 0 else { return }
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            if object.type == AVMetadataObject.ObjectType.qr {
                let alert = UIAlertController(title: "QR Code", message: object.stringValue, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Перейти", style: .default, handler: { (action) in
                    print(object.stringValue)
                }))
                alert.addAction(UIAlertAction(title: "Копировать", style: .default, handler: { (action) in
                    UIPasteboard.general.string = object.stringValue
                    self.view.layer.sublayers?.removeLast()
                    self.session.stopRunning()
                    print(object.stringValue)
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
}
