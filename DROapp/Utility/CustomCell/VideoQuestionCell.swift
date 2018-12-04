//
//  VideoQuestionCell.swift
//  DRO
//
//  Created by Carematix on 03/05/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import AVFoundation

class VideoQuestionCell: UITableViewCell {
    var helpText = String()
    
    @IBOutlet var labelQuestionNumber: UILabel!
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeSeekbar: UISlider!
    @IBOutlet weak var playerConstant: NSLayoutConstraint!
    @IBOutlet weak var videoPlayerSuperView: UIView!
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false
    var timer  = Timer()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        labelQuestion.setCustomFont()
        labelQuestionNumber.setCustomFont()
        //  self.setupMoviePlayer()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    // I have put the avplayer layer on this view
    
    //This will be called everytime a new value is set on the videoplayer item
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            /*
             If needed, configure player item here before associating it with a player.
             (example: adding outputs, setting text style rules, selecting media options)
             */
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
            // let currentAsset = (self.avPlayer?.currentItem?.asset)!
            
        }
    }
    
    func setupMoviePlayer(url: URL){
        
        if self.avPlayer == nil {
            let asset = AVURLAsset(url: url)
            self.avPlayer = AVPlayer.init(playerItem: AVPlayerItem(asset: asset))
        }
        //avPlayerLayer = AVPlayerLayer(player: avPlayer)
        
        let currentTime = self.avPlayer?.currentItem?.asset.duration.seconds
        let currentAsset = (self.avPlayer?.currentItem?.asset)!
        
        
        
        // AVURLAsset *asset = [AVURLAsset assetWithURL: url];
        // AVPlayerItem *item = [AVPlayerItem playerItemWithAsset: asset];
        
        let currentAssetSize = currentAsset.screenSize
        timeSeekbar.maximumValue = Float(currentTime!)
        timeSeekbar.isContinuous = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let size = currentAssetSize , size.height != 0  {
                videoPlayerSuperView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 149 , height: ((currentAssetSize?.height)! / (currentAssetSize?.width)! ) * ( UIScreen.main.bounds.size.width - 149 ))
            }else{
                videoPlayerSuperView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 149 , height: 300)
                
            }
        } else {
            if let size = currentAssetSize , size.height != 0  {
                videoPlayerSuperView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 30 , height: ((currentAssetSize?.height)! / (currentAssetSize?.width)! ) * ( UIScreen.main.bounds.size.width - 30) )
                
            }else{
                videoPlayerSuperView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 30 , height: 200 )
                
            }
            
            
        }
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        avPlayer?.actionAtItemEnd = .none
        
        if(UIDevice.current.userInterfaceIdiom == .pad){
            if let size = currentAssetSize , size.height != 0  {
                
                avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 149, height: ((currentAssetSize?.height)! / (currentAssetSize?.width)! ) * (UIScreen.main.bounds.size.width - 149 ) )
            }else{
                avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 149, height:280)
                
            }
            
        }else{
            
            if let size = currentAssetSize , size.height != 0  {
                avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width , height: ((currentAssetSize?.height)! / (currentAssetSize?.width)! ) * (UIScreen.main.bounds.size.width  ) )
                
            }else{
                avPlayerLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 30, height: 180 )
                
            }
            
        }
        
        self.backgroundColor = .lightGray
        
        if(UIDevice.current.userInterfaceIdiom == .pad){
            if let size = currentAssetSize , size.height != 0  {
                 playerConstant.constant = (((currentAssetSize?.height)! / (currentAssetSize?.width)! ) * (UIScreen.main.bounds.size.width - 149))

            }else{
                playerConstant.constant = 280

            }
        }else{
            if let size = currentAssetSize , size.height != 0  {
                playerConstant.constant = ((currentAssetSize?.height)! / (currentAssetSize?.width)! ) * (UIScreen.main.bounds.size.width - 30)

            }else{
                 playerConstant.constant = 180
            }
            
            playerConstant.constant = 180 //((currentAssetSize?.height)! / (currentAssetSize?.width)! ) * (UIScreen.main.bounds.size.width - 30)
            
        }
        videoPlayerSuperView.layer.insertSublayer(avPlayerLayer!, at: 0)
        
        // This notification is fired when the video ends, you can handle it in the method.
        NotificationCenter.default.addObserver(self,selector: #selector(self.playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer?.currentItem)
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.updateSeekBar(notification:)), name: NSNotification.Name.AVPlayerItemTimeJumped, object: avPlayer?.currentItem)
        
        NotificationCenter.default.addObserver(self,selector: #selector(self.stopPlayingVideo(notification:)), name: NSNotification.Name(rawValue: "StopPlaying"), object:nil)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime(_ timer: Timer) {
        timeSeekbar.value = Float((self.avPlayer?.currentItem?.currentTime().seconds)!)
    }
    
    func stopPlayback(){
        self.avPlayer?.pause()
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "play"), for: .normal)
        timer.invalidate()
    }
    
    func startPlayback(){
        self.avPlayer?.play()
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "stop"), for: .normal)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateSeekBar (notification: Notification){
        let playerItem = notification.object as! AVPlayerItem
        timeSeekbar.value = Float(playerItem.currentTime().seconds)
        
    }
    @objc func stopPlayingVideo (notification: Notification){
        if self.avPlayer != nil {
            self.avPlayer?.pause()
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "play"), for: .normal)
            timer.invalidate()
        }
    }
    
    // A notification is fired and seeker is sent to the beginning to loop the video again
    @objc func playerItemDidReachEnd(notification: Notification) {
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "play"), for: .normal)
        timer.invalidate()
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: CMTime.zero, completionHandler: nil)
        self.avPlayer?.pause()
    }
    
    @IBAction func playPauseVideo(_ sender: UIButton) {
        if self.avPlayer?.timeControlStatus == .playing {
            stopPlayback()
        }else{
            startPlayback()
        }
    }
    
    @IBAction func seetTo(_ sender: UISlider) {
        self.avPlayer?.seek(to: CMTime(seconds: Double(sender.value), preferredTimescale: 1))
    }
    
    @IBAction func showHint(_ sender: UIButton) {
        let view = CustomSuccessAlert.instanceFromNib(message: helpText)
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    
}
