//
//  ViewController.swift
//  AudioPreprocessing
//
//  Created by Ashley Wilke on 11/22/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var PlayBTN: UIButton!
    @IBOutlet weak var RecordBTN: UIButton!
    
    var soundRecorder : AVAudioRecorder!
    var soundPlayer : AVAudioPlayer!
    var fileName = "audioFile.wav"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupRecorder()
    }
    
    func setupRecorder(){
        let recordSettings: [String: Any] = [AVFormatIDKey: kAudioFormatLinearPCM,
                   AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                   AVEncoderBitRateKey: 320000,
                   AVNumberOfChannelsKey: 2,
                   AVSampleRateKey: 44100.0 ]
        
        soundRecorder = try! AVAudioRecorder(url: getFileURL(), settings: recordSettings)
        
        soundRecorder.delegate = self
        soundRecorder.prepareToRecord()
    }
    
    func getCacheDirectory() -> String{
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) 
        
        return paths[0]
    }
    
    func getFileURL() -> URL{
        let path = getCacheDirectory().appending(fileName)
        
        let filePath = URL(fileURLWithPath: path)
        
        return filePath
    }
    
    @IBAction func Record(_ sender: UIButton) {
        if sender.titleLabel?.text == "Record"{
        soundRecorder.record()
            sender.setTitle("Stop", for: .normal)
            PlayBTN.isEnabled = false
        }
        else{
            soundRecorder.stop()
            sender.setTitle("Record", for: .normal)
            PlayBTN.isEnabled = false
        }
    }
    
    @IBAction func Play(_ sender: UIButton) {
        if sender.titleLabel?.text == "Play"{
            RecordBTN.isEnabled = false
            sender.setTitle("Stop", for: .normal)
            preparePlayer()
            soundPlayer.play()
        }
        else{
            soundPlayer.stop()
            sender.setTitle("Play", for: .normal)
        }
    }
    
    func preparePlayer(){
        soundPlayer = try! AVAudioPlayer(contentsOf: getFileURL())
        soundPlayer.delegate = self
        soundPlayer.prepareToPlay()
        soundPlayer.volume = 1.0
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        PlayBTN.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        RecordBTN.isEnabled = true
        PlayBTN.setTitle("Play", for: .normal)
    }

}

