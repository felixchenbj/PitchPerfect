//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by felix on 8/1/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var darthvaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: NSURL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: NSTimer!
    
    enum ButtonType: Int {
        case Slow = 0
        case Fast
        case Chipmunk
        case Darthvader
        case Echo
        case Reverb
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudio()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureUI(.NotPlaying)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func effectButtonPressed(sender: UIButton) {
        print("Effect button pressed!")
        
        switch(ButtonType(rawValue: sender.tag)!) {
        case .Slow:
            playSound(rate: 0.5)
        case .Fast:
            playSound(rate: 1.5)
        case .Chipmunk:
            playSound(pitch: 1000)
        case .Darthvader:
            playSound(pitch: -1000)
        case .Echo:
            playSound(echo: true)
        case .Reverb:
            playSound(reverb: true)
        }
        configureUI(.Playing)
    }
    
    @IBAction func stopPlaying(sender: AnyObject) {
        stopAudio()
    }
    
}
