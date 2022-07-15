//
//  ImagePickerViewController.swift
//  social-network-app
//
//  Created by user on 14/7/22.
//

import UIKit
import PhotosUI

class ImagePickerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAddImageOptionAlert() {
        DispatchQueue.main.async {
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            sheet.addAction(UIAlertAction(title: "Photo Library", style: .default) {_ in
                // show image library of the device
                self.showDeviceImageLibrary()
            })
            
            sheet.addAction(UIAlertAction(title: "Camera", style: .default) {_ in
                self.didTapCamera()
            })
            
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.navigationController?.present(sheet, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - DEVICE IMAGES
    func showDeviceImageLibrary() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        DispatchQueue.main.async {
            switch status {
            case .notDetermined:
                self.requestAccess()
            case .restricted, .denied:
                self.presentErrorAlert(title: "Error", message: "Permission is needed. Please add the permission from settings")
            case .authorized, .limited:
                self.presentDeviceImageViewController()
            @unknown default:
                break
            }
        }
    }
    
    func requestAccess() {
        PHPhotoLibrary.requestAuthorization {status in
            self.showDeviceImageLibrary()
        }
    }
    
    func presentDeviceImageViewController() {
        let vc = DeviceImageLibraryViewController()
        vc.delegate = self
        
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - CAMERA
    func didTapCamera() {
        let auth = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch auth {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {granted in
                DispatchQueue.main.async {
                    if granted {
                        self.presentCamera()
                    } else {
                        self.presentErrorAlert(title: "Error", message: "Camera permission is needed. Please add the permission from settings")
                    }
                }
                
            }
        case .restricted, .denied:
            self.presentErrorAlert(title: "Error", message: "Camera permission is needed. Please add the permission from settings")
        case .authorized:
            self.presentCamera()
        @unknown default:
            return
        }
    }
    
    func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {return}
        
        let cameraVC = UIImagePickerController()
        cameraVC.delegate = self
        cameraVC.sourceType = .camera
        cameraVC.cameraDevice = .rear
        
        navigationController?.present(cameraVC, animated: true)
    }
    
    private func presentErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Go Settings", style: .default) {action in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {return}
            
            UIApplication.shared.open(settingsURL)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(alert, animated: true)
        
    }
    
    // OVERRIDE THIS FUNCTION
    func setImage(data: Data) {
        print("Set Image")
    }

}

// CAMERA DELEGATE
extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage, let data = image.jpegData(compressionQuality: 0.5) {
            picker.dismiss(animated: true) {
                self.setImage(data: data)
            }
        }
    }
}

// DEVICE DELEGATE
extension ImagePickerViewController: DeviceImageLibraryViewControllerDelegate {
    func onDevicePhotoSelected(selectedAsset: PHAsset) {
        selectedAsset.image(isSynchronous: true) {image in
            if let data = image?.jpegData(compressionQuality: 0.5) {
                self.setImage(data: data)
            }
        }
    }
}
