//
//  EditProfileNameCell.swift
//  DROapp
//
//  Created by Carematix on 08/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import AVKit
import Photos

@objc protocol EditProfileNameCellDelegate {
    @objc func saveImageData( data: Data , cell: EditProfileNameCell)
}

class EditProfileNameCell: UITableViewCell {
    
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var labelUsername: UILabel!
    @IBOutlet var labelEdit: UILabel!
    @IBOutlet var labelLastName: UILabel!
    @IBOutlet var textfieldLastName: UITextField!
    @IBOutlet var textfieldFirstName: UITextField!
    
    weak var delegate: EditProfileNameCellDelegate?
    var imagePicker = UIImagePickerController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagePicker.delegate = self
        labelEdit.setCustomFont()
        labelUsername.setCustomFont()
        labelLastName.setCustomFont()
        textfieldLastName.setCustomFont()
        textfieldFirstName.setCustomFont()
        labelEdit.text = kEdit.localisedString()
        DispatchQueue.main.async {
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height / 2
            self.imgProfile.contentMode = .scaleAspectFill

            self.imgProfile.clipsToBounds = true
        }// Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func changePic(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: "Change Photo", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
            visibleController.present(alert, animated: true, completion: nil)

        }
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                DispatchQueue.main.async {
                    if response {
                        self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                        
                        self.imagePicker.allowsEditing = true
                        
                        if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                            visibleController.present(self.imagePicker, animated: true, completion: nil)
                        }
                        
                    } else {
                        let alert  = UIAlertController(title: "Warning", message: "Please enable camera permission from Device Setting", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                            visibleController.present(alert, animated: true, completion: nil)
                        }
                    }
                }
               
            }
        }else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                visibleController.present(alert, animated: true, completion: nil)

            }
        }
    }
    
    func openGallary()
    {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    DispatchQueue.main.async {
                        self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                        self.imagePicker.allowsEditing = true
                        if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                            visibleController.present(self.imagePicker, animated: true, completion: nil)
                            
                        }
                    }
                    
                } else {
                    let alert  = UIAlertController(title: "Warning", message: "Please enable photo library permission from Device Setting", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                        visibleController.present(alert, animated: true, completion: nil)
                        
                    }
                }
            })
        }else if photos == .authorized{
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.imagePicker.allowsEditing = true
            if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                visibleController.present(self.imagePicker, animated: true, completion: nil)
                
            }
        }else {
            let alert  = UIAlertController(title: "Warning", message: "Please enable photo library permission from Device Setting", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                visibleController.present(alert, animated: true, completion: nil)
                
            }
        }
        
        
    }

}
extension EditProfileNameCell :UIImagePickerControllerDelegate ,  UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            self.imgProfile.image = resizeImage(image:  image)

        }
        
        let data = self.imgProfile.image!.jpegData(compressionQuality: 0.2)

        if let delegat = delegate {
            delegat.saveImageData(data: data!, cell: self)
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        let size = image.size
        if size.width < 400 || size.height < 400 {
            return image
        }
        var newImage = image
        
        let widthRatio  = 400  / size.width
        let heightRatio = 400 / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio < heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        }else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = false
            let renderer = UIGraphicsImageRenderer(bounds:  CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height ) , format: renderFormat)
            newImage = renderer.image {
                (context) in
                image.draw(in: CGRect(x: 0, y: 0 , width: newSize.height , height: newSize.height ))
            }
        }else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), false, 0)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        return newImage
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
