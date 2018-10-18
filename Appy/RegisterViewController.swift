//
//  RegisterViewController.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/17/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import UIKit
import ChameleonFramework
import VideoSplashKit

class RegisterViewController: VideoSplashViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordConfirmText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addVideo(videoName: "test2", videoType: "mp4")
        
        keyboardDismiss()
    }
    
    @IBAction func pressedRegister(_ sender: UIButton) {
        performSegue(withIdentifier: "goToHomePageFromRegister", sender: self)
    }
    
    @IBAction func pressedLogin(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLoginFromRegister", sender: self)
    }
    
    @IBAction func pressedForgot(_ sender: UIButton) {
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
    
    // Dismiss Keyboard Function
    func keyboardDismiss() -> Void {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
}

