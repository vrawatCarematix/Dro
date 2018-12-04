//
//  VideoAnswerCell.swift
//  DROapp
//
//  Created by Carematix on 21/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit
class VideoAnswerCell: UITableViewCell {
    
    //MARK:- Outlet
    @IBOutlet var viewRecord: UIView!
    @IBOutlet var labelCapture: UILabel!
    @IBOutlet var labelTapHere: UILabel!
    @IBOutlet var imgRemove: UIImageView!
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var imgPlay: UIImageView!
    @IBOutlet var imgThumbnail: UIImageView!
    @IBOutlet var imgDot: UIImageView!
    
    //MARK:- Variable

    let playerViewController = AVPlayerViewController()
    var videoUrl = URL(fileURLWithPath: "")
    var videoPicker = UIImagePickerController()
    var videoFileName = String()
    var media = MediaModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelCapture.setCustomFont()
        labelTapHere.setCustomFont()
        removeButton.setCustomFont()
        imgPlay.isHidden = true
        imgRemove.isHidden = true
        removeButton.isHidden = true

        imgThumbnail.layer.cornerRadius = 10.0
        imgDot.layer.cornerRadius = 10.0

        // Initialization code
    }

   
    func configureCell()  {
        var fileExist = false
        if let name = media.name , name != ""{
            let manager = FileManager.default
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            if let localPath = documentDirectory?.appending("/" + name){
                if localPath != "/" && localPath != "" && manager.fileExists(atPath: localPath){
                    videoUrl = URL(fileURLWithPath: localPath)
                    imgThumbnail.image =  getThumbnailFrom(path: videoUrl)

                    fileExist = true
                }
            }
        }
        if fileExist{
            labelTapHere.isHidden = true
            labelCapture.isHidden = true
            imgPlay.isHidden = false
            removeButton.isHidden = false
            imgRemove.isHidden = false
            imgDot.image = #imageLiteral(resourceName: "borderImage")
            imgPlay.isHidden = false
            viewRecord.isHidden = true
        }else{
            labelTapHere.isHidden = false
            labelCapture.isHidden = false
            imgPlay.isHidden = true
            removeButton.isHidden = true
            imgRemove.isHidden = true
            imgDot.image = #imageLiteral(resourceName: "dotLineImage")
            imgPlay.isHidden = true
            viewRecord.isHidden = false
        }
    }

    func deleteOldRecording(){
        
        if let name = media.name{
            let manager = FileManager.default
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            if let localPath = documentDirectory?.appending("/" + name){
                if localPath != "/" && localPath != "" && manager.fileExists(atPath: localPath){
                    do {
                        try  manager.removeItem(atPath: localPath)
                        videoUrl = URL(fileURLWithPath: "")
                    }
                    catch(_){
                        
                    }
                }
            }
        }
        
    }
    
    @IBAction func removeVideo(_ sender: UIButton) {
        labelTapHere.isHidden = false
        labelCapture.isHidden = false
        imgPlay.isHidden = true
        viewRecord.isHidden = false
        removeButton.isHidden = true
        imgRemove.isHidden = true
        imgDot.image = #imageLiteral(resourceName: "dotLineImage")
        imgThumbnail.image = nil
        deleteOldRecording()
        videoUrl  = URL(fileURLWithPath: "")
        media.name = ""
        let _ = DatabaseHandler.insertIntoMedia(media: media)

    }
    
    
    @IBAction func openCamera(_ sender: UIButton) {
        
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            DispatchQueue.main.async {
                
                if response {
                    
                    
                    if self.imgThumbnail.image == nil {
                        self.deleteOldRecording()
                        if UIImagePickerController.isSourceTypeAvailable( .camera)  {
                            self.videoPicker.sourceType = UIImagePickerController.SourceType.camera
                            self.videoPicker.mediaTypes = ["public.movie"]
                            
                            self.videoPicker.cameraCaptureMode = .video
                            self.videoPicker.delegate = self
                            self.videoPicker.allowsEditing = true
                            self.videoPicker.videoMaximumDuration = 15
                            self.videoPicker.videoQuality = .type640x480
                            if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                                visibleController.present(self.videoPicker, animated: true, completion: nil)
                                
                            }
                        }else if UIImagePickerController.isSourceTypeAvailable( .photoLibrary)  {
                            
                            // videoPicker.cameraCaptureMode = .video
                            self.videoPicker.delegate = self;
                            self.videoPicker.allowsEditing = true
                            self.videoPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                            self.videoPicker.mediaTypes = [kUTTypeMovie] as [String]
                            self.videoPicker.videoMaximumDuration = 15
                            self.videoPicker.videoQuality = .type640x480
                            if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                                visibleController.present(self.videoPicker, animated: true, completion: nil)
                                
                            }
                        }
                    }else{
                        self.playVideo()
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
        
        
       
    }
   

    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        //present(alert, animated: true, completion: nil)
    }
    
    func getThumbnailFrom(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    func playVideo(){
        
        let player = AVPlayer(url: videoUrl)
        playerViewController.player = player
           NotificationCenter.default.addObserver(self,selector: #selector(self.playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)
        if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
            visibleController.present(playerViewController, animated: true) {
                self.playerViewController.player!.play()
            }
        }
      
    }
    @objc func playerItemDidReachEnd(notification: Notification) {
        playerViewController.dismiss(animated: true, completion: nil)
    }
    func saveFile(url : URL)  {
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
             videoFileName = "\(Date().timeIntervalSince1970)"

            let filePath = videoFileName + ".mov"
            let fileURL = documentDirectory.appendingPathComponent(filePath)
            if !fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.copyItem(atPath: url.path, toPath: fileURL.path)
                videoUrl = fileURL
                media.name = filePath
                let _ = DatabaseHandler.insertIntoMedia(media: media)
            }
        } catch {
            print(error)
        }
     
    }

}
extension VideoAnswerCell: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        //dismiss(animated: true, completion: nil)
        labelTapHere.isHidden = true
        labelCapture.isHidden = true
        imgPlay.isHidden = false
        removeButton.isHidden = false
        imgRemove.isHidden = false
        imgDot.image = #imageLiteral(resourceName: "borderImage")
        imgPlay.isHidden = false
        viewRecord.isHidden = true
        
        guard
            let mediaType = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? URL,
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
            else {
                return
        }
        
        imgThumbnail.image =  getThumbnailFrom(path: url)
        videoUrl = url
        saveFile(url: url)
        picker.dismiss(animated: true, completion: nil)
        
        // Handle a movie capture
        // UISaveVideoAtPathToSavedPhotosAlbum(
        //            url.path,
        //            self,
        //            #selector(video(_:didFinishSavingWithError:contextInfo:)),
        //            nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if imgThumbnail.image == nil {
            labelTapHere.isHidden = false
            labelCapture.isHidden = false
            imgPlay.isHidden = true
            removeButton.isHidden = true
            imgRemove.isHidden = true
            imgDot.image = #imageLiteral(resourceName: "dotLineImage")
            imgPlay.isHidden = true
            viewRecord.isHidden = false
            media.name = ""
            let _ = DatabaseHandler.insertIntoMedia(media: media)
        }else{
            labelTapHere.isHidden = true
            labelCapture.isHidden = true
            imgPlay.isHidden = false
            removeButton.isHidden = false
            imgRemove.isHidden = false
            imgDot.image = #imageLiteral(resourceName: "borderImage")
            imgPlay.isHidden = false
            viewRecord.isHidden = true
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}


extension VideoAnswerCell: UINavigationControllerDelegate {
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
