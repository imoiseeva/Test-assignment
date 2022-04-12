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
    
    private lazy var IPAddressLabel: UILabel = {
        let lable = UILabel()
        lable.text = "Your IP Address"
        lable.font = UIFont.systemFont(ofSize: 15.0)
        lable.textColor = .gray
        lable.textAlignment = .left
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private lazy var getIPButton: UIButton = {
        let button = UIButton()
        button.setTitle("What's my address?", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 1
        )
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(fetchIP), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var gettingDarkButton: UIButton = {
        let button = UIButton()
        button.setTitle("It's getting dark", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 1
        )
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(toggleFlashLight), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var freezingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Brrrr, It's freezing!", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 1
        )
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(freezing), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var askingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ask Me Anything", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 1
        )
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(asking), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var imageForAsking: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ball1")
        image.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var QRButton: UIButton = {
        let button = UIButton()
        button.setTitle("SCAN QR", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 1
        )
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(setupVideo), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var video = AVCaptureVideoPreviewLayer()
    private let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupIUElements()
        setConstraints()
    }
    
    private func setupNavigationBar() {
        title = "Test assignment"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarApearence = UINavigationBarAppearance()
        navBarApearence.configureWithOpaqueBackground()
        navBarApearence.backgroundColor = UIColor(
            red: 192/255,
            green: 192/255,
            blue: 192/255,
            alpha: 194/255
        )
        navigationController?.navigationBar.standardAppearance = navBarApearence
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApearence
        
        navigationController?.navigationBar.tintColor = .white
    }
    private func setupIUElements() {
        view.addSubview(IPAddressLabel)
        view.addSubview(getIPButton)
        view.addSubview(gettingDarkButton)
        view.addSubview(freezingButton)
        view.addSubview(askingButton)
        view.addSubview(imageForAsking)
        view.addSubview(QRButton)
        
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            IPAddressLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            IPAddressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            IPAddressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            getIPButton.topAnchor.constraint(equalTo: IPAddressLabel.bottomAnchor, constant: 10),
            getIPButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            getIPButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            gettingDarkButton.topAnchor.constraint(equalTo: getIPButton.bottomAnchor, constant: 20),
            gettingDarkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            gettingDarkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            freezingButton.topAnchor.constraint(equalTo: gettingDarkButton.bottomAnchor, constant: 20),
            freezingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            freezingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            askingButton.topAnchor.constraint(equalTo: freezingButton.bottomAnchor, constant: 20),
            askingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            askingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            imageForAsking.topAnchor.constraint(equalTo: askingButton.bottomAnchor, constant: 10),
            imageForAsking.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageForAsking.widthAnchor.constraint(equalToConstant: 130),
            imageForAsking.heightAnchor.constraint(equalToConstant: 130),

            QRButton.topAnchor.constraint(equalTo: imageForAsking.bottomAnchor, constant: 20),
            QRButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            QRButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    // MARK: - Methods
    
    @objc private func fetchIP() {
        IPAddressLabel.text = NetworkManager.shared.fetchInfo()
    }
    
    @objc private func toggleFlashLight() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video),
              device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            if device.torchMode == AVCaptureDevice.TorchMode.on {
                device.torchMode = AVCaptureDevice.TorchMode.off
                gettingDarkButton.setTitle("It's getting dark", for: .normal)
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                    gettingDarkButton.setTitle("You're blinding me", for: .normal)
                } catch {
                    print(error)
                }
            }
            device.unlockForConfiguration()
        } catch {
            assert(false, "error: device flash light, \(error)")
        }
    }
    
    @objc func freezing() {
        for _ in 1...3 {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            sleep(1)
        }
    }
    
    @objc private func asking() {
        let ballArray = [#imageLiteral(resourceName: "ball1.png"),#imageLiteral(resourceName: "ball2.png"),#imageLiteral(resourceName: "ball3.png"),#imageLiteral(resourceName: "ball4.png"),#imageLiteral(resourceName: "ball5.png")]
        imageForAsking.image = ballArray[Int.random(in: 0...4)]
    }
    
    @objc private func setupVideo() {
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
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
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

