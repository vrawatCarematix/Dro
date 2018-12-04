//
//  AudioRecoderView.swift
//  AudioRecorder
//
//  Created by webwerks on 7/26/17.
//  Copyright © 2017 Neosoft. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


protocol AudioRecoderViewDelegate{
    func closeAudioRecording()
    func submitAudioViewRecording( recorderView : AudioRecoderView)

}
class AudioRecoderView : UIView {
    
    @IBOutlet var closeButton: UIButton!
    // MARK : Variables
    var audioRecorder : AVAudioRecorder!
    var settings = [String : Int]()
    var timer : Timer!
    var fileName = String()

    var delegate: AudioRecoderViewDelegate?
    var audioSession : AVAudioSession?
    var rootController : UIViewController!

    var isRecordingStart = false
    var counter = 0
    // MARK : Outlets
    @IBOutlet weak var recordImage: UIImageView!
    @IBOutlet weak var recordTime: UILabel!
    
    class func instanceFromNib(fileName : String) -> AudioRecoderView {
       let view =  UINib(nibName: "AudioRecoderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AudioRecoderView
        view.fileName = fileName
        return view
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recordTime.setCustomFont()
        closeButton.setCustomFont()
        closeButton.setTitle("Start", for: .normal)
        recordImage.isUserInteractionEnabled = true
      //  recordImage.addGestureRecognizer(longPress)
      //  longPress.minimumPressDuration = 0.1
       // recordImage.image = UIImage(named: "speech.gif")
        recordImage.image = UIImage(named: "speech50.gif" )!
        var imageArray = [UIImage]()
        for i in 0...50{
            imageArray.append( UIImage(named: "speech\(i).gif" )!)
        }
        recordImage.animationImages = imageArray //[UIImage(named: "audio")!,UIImage(named: "audio1")!]
        recordImage.animationDuration  = 5
       // recordImage.startAnimating()

                //delete old file
       // AudioRecoderView.deleteOldRecording()
    }
     func deleteOldRecording(){
        let audioFilename = getAudioFilePath().path
        let manager = FileManager.default
        if manager.fileExists(atPath: audioFilename){
            do {
                try  manager.removeItem(atPath: audioFilename)
            }
            catch(_){
                
            }
        }

    }

    
    @IBAction func closeAudio(sender:Any){
        //send protocol call Back
        if !isRecordingStart {
            closeButton.setTitle("Done", for: .normal)
            startRecording()
            isRecordingStart = true
        }
        else {
            closeButton.setTitle("Start", for: .normal)

            isRecordingStart = false

            if audioRecorder == nil {
                delegate?.closeAudioRecording()
            }else{
                
                
                self.resetAudioRecordingData()
                self.delegate?.submitAudioViewRecording(recorderView: self)

            }
        }
        
    }
    
    
     func getAudioFilePath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]

        let audioFilename = documentsDirectory.appendingPathComponent( fileName + ".m4a")
        return audioFilename
    }
    
    
    @objc func getTime(time : Timer){
        counter += 1
        let res = AudioRecoderView.stringFromTimeInterval(interval: counter)
        recordTime.text = res as String
    }
    
    static func stringFromTimeInterval(interval: Int) -> NSString {
        let ti = interval
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
    
    // MARK : To Record Audio
    func startRecording(){
        do {
            
            let audioFilename = getAudioFilePath()
            let manager = FileManager.default
            if manager.fileExists(atPath: audioFilename.path){
                deleteOldRecording()
            }
            settings = [
                AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey : 44100,
                AVNumberOfChannelsKey : 2,
                AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue
            ]
            
            audioSession = AVAudioSession.sharedInstance()
            
            
            try audioSession?.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            try audioSession?.setActive(true, options: .notifyOthersOnDeactivation)
            
           // try audioSession?.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord)), mode: .default)
            
               // try AVAudioSession.sharedInstance().setActive(true)
           
           // try audioSession?.setCategory(<#T##category: AVAudioSession.Category##AVAudioSession.Category#>, mode: <#T##AVAudioSession.Mode#>, options: <#T##AVAudioSession.CategoryOptions#>)
            
            
            //(convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord))
            try audioSession?.setActive(true)
            
            
            audioRecorder = try AVAudioRecorder(url:audioFilename ,settings: settings)
            audioRecorder.record()
            
            recordImage.startAnimating()
            let res = AudioRecoderView.stringFromTimeInterval(interval: counter)
            recordTime.text = res as String
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:
                #selector(getTime), userInfo: nil, repeats: true)
            
        } catch _ {
            resetAudioRecordingData()
            closeAudio(sender: UIButton())
        }
    }
    
    func resetAudioRecordingData(){
        if audioRecorder != nil {
            audioRecorder.stop()
        }
        audioRecorder = nil
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        recordImage.stopAnimating()
        counter = 0
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
