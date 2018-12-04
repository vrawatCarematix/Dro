//
//  TermAudioCell.swift
//  DROapp
//
//  Created by Carematix on 07/08/18.
//  Copyright © 2018 Carematix. All rights reserved.
//

import UIKit
import AVFoundation

class TermAudioCell: UITableViewCell {

 
    @IBOutlet weak var labelQuestion: UILabel!
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var timeSeekbar: UISlider!
    @IBOutlet weak var playerConstant: NSLayoutConstraint!
    @IBOutlet weak var videoPlayerSuperView: UIView!
    var avPlayer: AVPlayer?
    var paused: Bool = false
    
    var timer  = Timer()
    
    var avPlayerLayer: AVPlayerLayer?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        labelQuestion.setCustomFont()
        
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
        }
    }
    
    func setupMoviePlayer(url: URL){
        let currentAsset = AVAsset(url: url)
        if self.avPlayer == nil {
            
            self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        }
        let currentTime = currentAsset.duration.seconds
        
        timeSeekbar.maximumValue = Float(currentTime)
        timeSeekbar.isContinuous = true
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // avPlayer?.volume = 0
        avPlayer?.actionAtItemEnd = .none
        
        self.backgroundColor = .lightGray
        
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
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .normal)
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
    
    @IBAction func seekTo(_ sender: UISlider) {
        self.avPlayer?.seek(to: CMTime(seconds: Double(sender.value), preferredTimescale: 1))
    }
    
    
}
