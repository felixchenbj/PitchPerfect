//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by felix on 8/1/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordTimerLabel: UILabel!

    var audioRecorder:AVAudioRecorder!
    
    var recordingTimer: NSTimer!
    
    var currentState: RecordState = .Recording
    
    var timerCount:Float = 0.0
    
    enum RecordState {
        case Recording
        case Stopped
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // disable the stoprecord button
        stopButton.enabled = false
        
        // hide the timer label
        recordTimerLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: AnyObject) {
        currentState = .Recording
        updateUI()
        
        // start the timer
        recordingTimer = NSTimer( timeInterval: 0.1, target: self, selector: #selector(RecordSoundsViewController.updateTimerUI), userInfo: nil, repeats: true)
        
         NSRunLoop.mainRunLoop().addTimer(self.recordingTimer!, forMode: NSDefaultRunLoopMode)
        
        recordTimerLabel.hidden = false
        
        startToRecord()
    }
    

    func updateTimerUI() {
        recordTimerLabel.text = String(format:"%.1f", timerCount)
        timerCount += 0.1
    }
    
    
    @IBAction func stopButtonPressed(sender: AnyObject) {
        recordingTimer.invalidate()
        currentState = .Stopped
        updateUI()
        
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func startToRecord() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func updateUI() {
        if currentState == .Recording {
            // disable the record button
            recordButton.enabled = false
            // enable the stoprecord button
            stopButton.enabled = true
            
            recordingLabel.text = "Recording..."

        } else {
            // enable the record button
            recordButton.enabled = true
            // disable the stoprecord button
            stopButton.enabled = false
            
            recordingLabel.text = "Tap to record"
            recordTimerLabel.hidden = true
            
            timerCount = 0.0
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Saving recording")
        
        if flag {
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving of recording failed")
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

