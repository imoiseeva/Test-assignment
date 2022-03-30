//
//  ViewController.swift
//  Test assignment
//
//  Created by Irina Moiseeva on 29.03.2022.
//

import UIKit
import SwiftSoup
import Alamofire
import AudioToolbox
import AVFoundation

class ViewController: UIViewController{
    
    
    @IBOutlet weak var flashlightTextButton: UIButton!
    
    @IBOutlet weak var IPAddressLabel: UILabel!
    
    var parser = XMLParser()
    
    var courses: [Model] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let manager = ServerTrustManager(evaluators: ["whatismyip.akamai.com": DisabledEvaluator()])
        //        let session = Session(serverTrustManager: manager)
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

}

