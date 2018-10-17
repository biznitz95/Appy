//
//  ViewController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/17/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework
import VideoSplashKit

class ViewController: VideoSplashViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addVideo(videoName: "test", videoType: "mp4")
    }


    // Add Video Function
    func addVideo(videoName name: String, videoType type: String) -> Void {
        guard let myBundle = Bundle.main.path(forResource: name, ofType: type) else {fatalError("Could not find video!")}
        let url = NSURL.fileURL(withPath: myBundle)
        self.videoFrame = view.frame
        self.fillMode = .resizeAspectFill
        self.alwaysRepeat = true
        self.sound = false
        //        self.startTime = 12.0
        //        self.duration = 4.0
        self.alpha = 0.7
        self.backgroundColor = UIColor.black
        self.contentURL = url
        self.restartForeground = true
    }
}

