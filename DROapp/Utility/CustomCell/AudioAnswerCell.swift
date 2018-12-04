//
//  AudioAnswerCell.swift
//  DROapp
//
//  Created by Carematix on 21/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class AudioAnswerCell: UITableViewCell {

    //MARK:- Outlet
    @IBOutlet var seekbar: UISlider!
    @IBOutlet var labelRecord: UILabel!
    @IBOutlet var labelTapHere: UILabel!
    @IBOutlet var imgMic: UIImageView!
    @IBOutlet var imgDot: UIImageView!
    @IBOutlet var imgRemove: UIImageView!
    @IBOutlet var removeButton: UIButton!
    
    //MARK:- Variable

    var audioFileName = String()
    var audioUrl = URL(fileURLWithPath: "")
    var audioView : AudioRecoderView?
    var player: AVAudioPlayer?
    var timer  = Timer()
    var media = MediaModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        labelRecord.setCustomFont()
        removeButton.setCustomFont()
        labelTapHere.setCustomFont()
        imgRemove.isHidden = true
        removeButton.isHidden = true
        seekbar.isHidden = true
        NotificationCenter.default.addObserver(self,selector: #selector(self.stopPlayingAudio(notification:)), name: NSNotification.Name(rawValue: "StopPlaying"), object:nil)
        // Initialization code
    }
    
    @objc func stopPlayingAudio(notification: Notification){
        self.player?.pause()
        self.player = nil
        imgMic.image = #imageLiteral(resourceName: "play")
        timer.invalidate()
    }
    //MARK:- Initialise Cell
    func configureCell()  {
        var fileExist = false
        if let name = media.name{
            let manager = FileManager.default
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            if let localPath = documentDirectory?.appending("/" + name){
                if localPath != "/" && localPath != "" && manager.fileExists(atPath: localPath){
                    audioUrl = URL(fileURLWithPath: localPath)
                    fileExist = true
                }
            }
        }
        if fileExist{
            labelRecord.text = "to play the audio"
            imgMic.image = #imageLiteral(resourceName: "play")
            removeButton.isHidden = false
            imgRemove.isHidden = false
            seekbar.isHidden = false
        }else{
            labelRecord.text = "to record the audio"
            removeButton.isHidden = true
            imgRemove.isHidden = true
            seekbar.isHidden = true
            imgMic.image = UIImage(named: "mic")
        }
    }
    
    class func CheckAudioPermission(completionHandler:@escaping(Bool) -> Void){
        AVAudioSession.sharedInstance().requestRecordPermission() {(granted: Bool)-> Void in
            DispatchQueue.main.async {
                if granted {
                    completionHandler(true)
                    // show
                } else {
                    completionHandler(false)
                }
            }
        }
    }
    
    func deleteOldRecording(){
        
        if let name = media.name{
            let manager = FileManager.default
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            if let localPath = documentDirectory?.appending("/" + name){
                if localPath != "/" && localPath != "" && manager.fileExists(atPath: localPath){
                    do {
                        try  manager.removeItem(atPath: audioUrl.path)
                        audioUrl = URL(fileURLWithPath: "")
                    }
                    catch(_){
                        
                    }
                }
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
  
    @IBAction func removeAudio(_ sender: UIButton) {
        stopPlayback()
        labelRecord.text = "to record the audio"
        removeButton.isHidden = true
        imgRemove.isHidden = true
        seekbar.isHidden = true
        imgMic.image = UIImage(named: "mic")

        deleteOldRecording()
        self.media.name = nil
        let _ = DatabaseHandler.insertIntoMedia(media: self.media)
    }
    
    @IBAction func recordAudio(_ sender: UIButton) {
        
        let manager = FileManager.default
        if audioUrl.path != "/" && audioUrl.path != "" && manager.fileExists(atPath: audioUrl.path){
            
            if self.player != nil {
                if (self.player?.isPlaying)! {
                    stopPlayback()
                }else{
                   startPlayback()
                }
            }else{
                do {
                    // try AVAudioSession.sharedInstance().setCategory(convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord))
                  //  try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                    
                  //  try AVAudioSession.sharedInstance().setActive(true)
                    
                    let audioSession = AVAudioSession.sharedInstance()
                    try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
                    try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                    
                    
                    /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
//                    if #available(iOS 11.0, *) {
//
//                    player = try AVAudioPlayer(contentsOf: audioUrl, fileTypeHint: AVFileType.mp3.rawValue)
//                    }else{
//                        player = try AVAudioPlayer(contentsOf: audioUrl, fileTypeHint: AVFileType.mp3.rawValue)
//
//                    }
                    player = try AVAudioPlayer(contentsOf: audioUrl, fileTypeHint: AVFileType.mp3.rawValue)

                    player?.delegate = self
                    let currentAsset = AVAsset(url: audioUrl)
                    
                    let currentTime = currentAsset.duration.seconds
                    
                    seekbar.maximumValue = Float(currentTime)
                    seekbar.isContinuous = true
                    /* iOS 10 and earlier require the following line:
                     player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
                    
                    guard let player = player else { return }
                    
                    player.play()
                    NotificationCenter.default.addObserver(self,selector: #selector(self.updateSeekBar(notification:)), name: NSNotification.Name.AVPlayerItemTimeJumped, object: player)
                    
                    NotificationCenter.default.addObserver(self,selector: #selector(self.stopPlayingVideo(notification:)), name: NSNotification.Name(rawValue: "StopPlaying"), object:nil)
                    
                    imgMic.image = #imageLiteral(resourceName: "stop")
                    
                    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                //try  manager.removeItem(atPath: audioUrl.path)
            }
        }else{
        
            AudioRecoderView.CheckAudioPermission { (isSuccess) in
                if isSuccess{
                    //let controller = self.alertWindow!.rootViewController!
                    self.audioView = AudioRecoderView.instanceFromNib(fileName: "\(Date().timeIntervalSince1970)")
                    self.audioView?.delegate = self
                    self.deleteOldRecording()

                    var rect = UIScreen.main.bounds
                    rect.origin.y = rect.size.height
                    self.audioView?.frame = rect
                    if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                        visibleController.view.addSubview(self.audioView!)
                        self.audioView?.rootController = visibleController
                        self.labelRecord.text = "to play the audio"
                        self.imgMic.image = #imageLiteral(resourceName: "play")
                        self.removeButton.isHidden = false
                        self.imgRemove.isHidden = false
                        self.seekbar.isHidden = false
                        UIView.animate(withDuration: 0.35, animations: {
                            rect.origin.y = 0
                            self.audioView?.frame = rect
                        })
                        
                    }
                    // controller.view.addSubview(self.audioView!)
                   
                }else{
                        let alert  = UIAlertController(title: "Warning", message: "Please enable microphone permission from Device Setting to record audio.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        if let visibleController = UIApplication.shared.keyWindow?.visibleViewController(){
                            visibleController.present(alert, animated: true, completion: nil)
                        }
                    
                    //self.hideWindow(nil,nil,nil)
                    
                }
            }
        }
        
    }
    @objc func updateSeekBar (notification: Notification){
       // let playerItem = notification.object as! AVPlayerItem
        seekbar.value = Float((self.player?.currentTime)!)

    }
    @objc func updateTime(_ timer: Timer) {
        
        seekbar.value = Float((self.player?.currentTime)!)
    }
    
    func stopPlayback(){
        self.player?.pause()
        self.player = nil
        imgMic.image = #imageLiteral(resourceName: "play")
        timer.invalidate()
        seekbar.value = 0
    }
    @objc func stopPlayingVideo (notification: Notification){
        if self.player != nil {
            self.player?.pause()
            imgMic.image = #imageLiteral(resourceName: "play")
            timer.invalidate()
            seekbar.value = 0

        }
    }
    
    func startPlayback(){
        self.player?.play()
        imgMic.image = #imageLiteral(resourceName: "stop")
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @IBAction func seekTo(_ sender: UISlider) {
        self.player?.currentTime = Double(sender.value) 
    }
   
}
extension AudioAnswerCell: AudioRecoderViewDelegate{
    
    public typealias viewRemoved = (_ isRemoved:Bool) -> ()
    
    func removeAudioView(completionHandler:@escaping viewRemoved){
        var rect = UIScreen.main.bounds
        UIView.animate(withDuration: 0.35, animations: {
            rect.origin.y = rect.size.height
            self.audioView?.frame = rect
        }, completion: { (isSuccess) in
            self.audioView?.removeFromSuperview()
            self.audioView = nil
            completionHandler(true)
        })
    }
    
    func closeAudioRecording(){
        removeAudioView { (remove) in
            //self.hideWindow(nil,nil,nil)
            // AudioRecoderView.deleteOldRecording()
        }
    }
    func submitAudioViewRecording(recorderView: AudioRecoderView) {
        
        removeAudioView { (remove) in
            self.audioUrl = recorderView.getAudioFilePath()
            
            self.media.name = self.audioUrl.lastPathComponent

            let _ = DatabaseHandler.insertIntoMedia(media: self.media)

            //            let manager = FileManager.default
            //            if manager.fileExists(atPath: audioFilename.path){
            //                do {
            //                    let data = try Data(contentsOf: audioFilename)
            //                    if data.count > 0 {
            //                        let playerItem = AVPlayerItem(url: audioFilename)
            //                        let currentDuration: Double = CMTimeGetSeconds(playerItem.asset.duration)
            //
            //                        //self.hideWindow(self.currentSelection,data,currentDuration)
            //                    }else{
            //                        self.hideWindow(nil,nil,nil)
            //                    }
            //                }
            //                catch(_){
            //                    self.hideWindow(nil,nil,nil)
            //                }
            //            }else{
            //                self.hideWindow(nil,nil,nil)
            //            }
        }
    }
    func hideWindow(_ selectedMessage: String?, _ messageData:Data?,_ mediaDuration:Double?){
        //  self.alertWindow?.isHidden = true
        //  self.alertWindow = nil
        //   self.completionBlock!(selectedMessage,messageData,mediaDuration ?? 0)
    }
}
extension AudioAnswerCell : AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        imgMic.image = #imageLiteral(resourceName: "play")
        timer.invalidate()
        self.player?.currentTime = Double(0)
        seekbar.value = Float((self.player?.currentTime)!)

        self.player?.pause()
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
