//
//  ImageAnswerCell.swift
//  DROapp
//
//  Created by Carematix on 20/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import AVKit
import Photos
class ImageAnswerCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet var removeButtonBottomImage: UIImageView!
    @IBOutlet var labelTapHere: UILabel!

    @IBOutlet var labelCapture: UILabel!
    @IBOutlet var imgCamrea: UIImageView!
    @IBOutlet var selectedImageView: UIImageView!
    @IBOutlet var outterImageView: UIImageView!
    @IBOutlet var removeButton: UIButton!
    
    //MARK:- Variables
    
    var imagePicker = UIImagePickerController()
    var media = MediaModel()
    
    //MARK:- View Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        imagePicker.delegate = self
        removeButton.isHidden = true
        
        removeButtonBottomImage.isHidden = true
        outterImageView.image = #imageLiteral(resourceName: "dotLineImage")
        selectedImageView.layer.cornerRadius = 10.0
        labelCapture.setCustomFont()
        labelTapHere.setCustomFont()
        removeButton.setCustomFont()
    }

    //MARK:- Initialise Cell

    func configureCell()  {
        if let name = media.name , name != "" {
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            if let localPath = documentDirectory?.appending("/" + name){
                let image    = UIImage(contentsOfFile: localPath)
                selectedImageView.image = image
            }
        }
        if selectedImageView.image == nil {
            self.media.name = nil
            labelTapHere.isHidden = false
            labelCapture.isHidden = false
            imgCamrea.isHidden = false
            removeButton.isHidden = true
            removeButtonBottomImage.isHidden = true
            outterImageView.image = #imageLiteral(resourceName: "dotLineImage")
        }else{
            labelTapHere.isHidden = true
            labelCapture.isHidden = true
            imgCamrea.isHidden = true
            removeButton.isHidden = false
            removeButtonBottomImage.isHidden = false
            outterImageView.image = #imageLiteral(resourceName: "borderImage")
        }
    }
    
    //MARK:- Button Action


    @IBAction func removeImage(_ sender: UIButton) {
        labelTapHere.isHidden = false
        labelCapture.isHidden = false
        imgCamrea.isHidden = false
        selectedImageView.image = nil
        removeButton.isHidden = true
        outterImageView.image = #imageLiteral(resourceName: "dotLineImage")
        deleteOldImage()

        removeButtonBottomImage.isHidden = true
        media.name = ""
        let _ = DatabaseHandler.insertIntoMedia(media: media)

    }
    @IBAction func addImage(_ sender: UIButton) {
        labelTapHere.isHidden = true
        labelCapture.isHidden = true
        imgCamrea.isHidden = true
        openCamera()

    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                DispatchQueue.main.async {
                    
                    if response {
                        if UIImagePickerController.isSourceTypeAvailable(.camera){
                            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                            
                        }else{
                            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                            
                        }
                        
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
            
        }else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                visibleController.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    func deleteOldImage(){
        
        if let name = media.name , name != ""{
            let manager = FileManager.default
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            if let localPath = documentDirectory?.appending("/" + name){
                if localPath != "/" && localPath != "" && manager.fileExists(atPath: localPath){
                    do {
                        try  manager.removeItem(atPath: localPath)
                    }
                    catch(_){
                        
                    }
                }
            }
        }
        
    }
    
    func openGallary(){
        deleteOldImage()
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    DispatchQueue.main.async {
                        self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
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

//MARK:- Button UIImagePickerControllerDelegate

extension ImageAnswerCell :UIImagePickerControllerDelegate ,  UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if selectedImageView.image == nil {
            self.media.name = nil
            labelTapHere.isHidden = false
            labelCapture.isHidden = false
            imgCamrea.isHidden = false
            removeButton.isHidden = true
            removeButtonBottomImage.isHidden = true
            outterImageView.image = #imageLiteral(resourceName: "dotLineImage")
            let _ = DatabaseHandler.insertIntoMedia(media: media)
        }else{
            labelTapHere.isHidden = true
            labelCapture.isHidden = true
            imgCamrea.isHidden = true
            removeButton.isHidden = false
            removeButtonBottomImage.isHidden = false
            outterImageView.image = #imageLiteral(resourceName: "borderImage")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        selectedImageView.image =  info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        labelTapHere.isHidden = true
        labelCapture.isHidden = true
        imgCamrea.isHidden = true
        removeButton.isHidden = false
        removeButtonBottomImage.isHidden = false
        outterImageView.image = #imageLiteral(resourceName: "borderImage")
        
        var imageName = "\(Date().timeIntervalSince1970)" + ".jpeg"
        
        if #available(iOS 11.0, *) {
            if let imageURL  = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.imageURL)] as? NSURL , let name = imageURL.lastPathComponent{
                imageName = name
                
            }
        } else {
            // Fallback on earlier versions
        }
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let localPath = documentDirectory?.appending("/" + imageName)
        
        let data = self.selectedImageView.image!.jpegData(compressionQuality: 0.2)
        do {
            try data?.write(to: URL(fileURLWithPath: localPath!), options: Data.WritingOptions(rawValue: 0))
            self.media.isUploaded = 0
            self.media.name = imageName
            let _ = DatabaseHandler.insertIntoMedia(media: media)
            
        }catch{
            debugPrint(error)
        }
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
