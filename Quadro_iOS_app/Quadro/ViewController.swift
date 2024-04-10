//
//  ViewController.swift
//  Quadro
//
//  Created by Oleksandr Nikolenko on 3/11/22.
//

import PinLayout
import TensorFlowLite
import UIKit
import CropViewController

class ViewController: UIViewController {
    
    // MARK: - Variables
    private let inputWidth = 128
    private let inputHeight = 64
    private var croppedAngle = 0
    private var croppedRect = CGRect.zero
    
    // Paths to models
    private let modelPaths: [String?] = [
        Bundle.main.path(forResource: "quadr_model", ofType: "tflite"),
        Bundle.main.path(forResource: "linear_model", ofType: "tflite"),
        Bundle.main.path(forResource: "constant_model", ofType: "tflite")
    ]
    // Maps labels to predicted number by index, e.g. if model predicts "0", the real number is at index 0, i.e. "-5"
    private let labelMap = ["-5", "-4", "-3", "-2", "-1", "1", "2", "3", "4", "5"]

    private lazy var photo = UIImageView().with {
        $0.contentMode = .scaleAspectFit
    }
    
    private let loadButton = UIButton().with {
        $0.setTitle("Load image", for: .normal)
        $0.backgroundColor = .systemBlue
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: Selector("buttonClicked:"), for: .touchUpInside)
    }
    
    private let titleLabel = UILabel().with {
        $0.text = "Quadratic equation coefficient extractor"
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let predictedLabel = UILabel().with {
        $0.text = "Predicted labels will appear here"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 22)
        $0.numberOfLines = 0
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(photo)
        view.addSubview(loadButton)
        view.addSubview(predictedLabel)
        view.addSubview(titleLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layout()
    }
    
    private func layout() {
        titleLabel.pin
            .top(view.pin.safeArea.top + 24)
            .horizontally(16)
            .sizeToFit(.width)
        
        loadButton.pin
            .height(60)
            .center()
            .width(150)
        
        photo.pin
            .verticallyBetween(titleLabel, and: loadButton)
            .hCenter()
            .width(UIScreen.main.bounds.width / 1.5)
            
        predictedLabel.pin
            .bottom(view.pin.safeArea.bottom + 48)
            .horizontally(16)
            .sizeToFit(.width)
    }
    
    @objc func buttonClicked(_ sender: AnyObject?) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.allowsEditing = true

        present(imagePickerController, animated: true, completion: nil)
    }
    
    func runModel(_ inputPhoto: UIImage?, modelPath: String?) -> Int {
        var predictedIndex = -1

        guard
            let inputPhoto = inputPhoto,
            let modelPath = modelPath
        else { return predictedIndex }
        
        guard let grayScaleData = inputPhoto.scaledData(with: CGSize(width: inputWidth, height: inputHeight))
        else {
            print("Failed to convert the image buffer to Grayscale data.")
            return predictedIndex
        }
        
        do {
            let interpreter = try Interpreter(modelPath: modelPath)
            
            try interpreter.allocateTensors()
            
            try interpreter.copy(grayScaleData, toInputAt: 0)
            try interpreter.invoke()
            
            let outputTensor = try interpreter.output(at: 0)
        
            let output = Array(outputTensor.data.toArray(type: Float32.self))
            let maximum = output.max()
            
            if let maximum = maximum {
                predictedIndex = output.firstIndex(of: maximum) ?? -1
            }
        } catch let err {
            print("An error occured: \(err)")
        }
        
        return predictedIndex
    }
    
}

// MARK: - Handles image picking
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage else { return }
        
        let isSimulator = true
        
        if !isSimulator {
            let cropController = CropViewController(croppingStyle: .default, image: image)
            cropController.delegate = self
                    
            picker.dismiss(animated: true) {
                self.present(cropController, animated: true, completion: nil)
            }
        } else {
            picker.dismiss(animated: true, completion: nil)
            
            var res: [String] = []
            
            for modelPath in modelPaths {
                let predictedInd = runModel(image, modelPath: modelPath)
                res.append(labelMap[predictedInd])
            }
            
            predictedLabel.text = "Predicted coefficients are: \n ["
                + res.map {"\($0) "}.reduce("") { $0 + $1 }.dropLast()
                + "]"
            
            self.photo.image = image
            self.view.setNeedsLayout()
        }
        
        
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        
        var res: [String] = []
        
        for modelPath in modelPaths {
            let predictedInd = runModel(image, modelPath: modelPath)
            res.append(labelMap[predictedInd])
        }
        
        predictedLabel.text = "Predicted coefficients are: \n ["
            + res.map {"\($0) "}.reduce("") { $0 + $1 }.dropLast()
            + "]"
        
        cropViewController.dismissAnimatedFrom(
            self,
            withCroppedImage: image,
            toView: nil,
            toFrame: CGRect.zero,
            setup: nil,
            completion: {
                self.photo.image = image
                self.view.setNeedsLayout()
        })
    }
    
}

