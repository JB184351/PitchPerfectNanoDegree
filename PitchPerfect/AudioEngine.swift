//
//  AudioEngine.swift
//  PitchPerfect
//
//  Created by Justin Bengtson on 7/30/22.
//

import Foundation
import AVFoundation
import UIKit

enum AudioEngineState {
    case playing
    case notPlaying
    case recording
}

protocol AudioEngineStateChangeDelegate: AnyObject {
    func didUpdateAudioState(with audioState: AudioEngineState)
}

class AudioEngine: NSObject {
    
    //MARK: - Public Properties
    
    weak var delegate: AudioEngineStateChangeDelegate?
    static let sharedInstance = AudioEngine()
    public private(set) var audioState: AudioEngineState = .notPlaying {
        didSet {
            delegate?.didUpdateAudioState(with: audioState)
        }
    }
    
    //MARK: - Private Properties
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var audioEngine = AVAudioEngine()
    private var audioFile = AVAudioFile()
    private var audioPlayerNode = AVAudioPlayerNode()
    private var stopTimer = Timer()
    private var audioRecordingSession = AVAudioSession.sharedInstance()
    
    private override init() {}
    
    //MARK: - AudioEngine Setup
    
    // Intializing audioPlayer here to make clear when I'm initializing and playing
    public func setupAudioPlayer(fileURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.delegate = self
            audioPlayer?.volume = 1.0
            audioPlayer?.isMeteringEnabled = true
        } catch {
            if let err = error as Error? {
                print("AVAudioPlayer error: \(err.localizedDescription)")
                audioPlayer = nil
            }
        }
    }
    
    // Intializing audioRecorder here to make clear
    // when I'm initializing the audioRecorder and actually recording
    public func setupRecorder(fileURL: URL) {
        let settings = [AVFormatIDKey: Int(kAudioFormatAppleLossless), AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                 AVEncoderBitRateKey : 320000, AVNumberOfChannelsKey: 2, AVSampleRateKey: 44100.0] as [String: Any]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
        } catch {
            if let err = error as Error? {
                print("AVAudioRecorder error: \(err.localizedDescription)")
                audioRecorder = nil
            } else {
                audioRecorder?.delegate = self
                audioRecorder?.prepareToRecord()
            }
        }
    }
    
    //==================================================
    // MARK: - Playback Controls
    //==================================================
    
    func playSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
        
        // initialize audio engine components
        let audioEngine = AVAudioEngine()
        
        // node for playing audio
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        // node for adjusting rate/pitch
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        audioEngine.attach(changeRatePitchNode)
        
        // node for echo
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho1)
        audioEngine.attach(echoNode)
        
        // node for reverb
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        audioEngine.attach(reverbNode)
        
        // connect nodes
        if echo == true && reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, reverbNode, audioEngine.outputNode)
        } else if echo == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, audioEngine.outputNode)
        } else if reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, reverbNode, audioEngine.outputNode)
        } else {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, audioEngine.outputNode)
        }
        
        // schedule to play and start the engine!
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil) {
            
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                
                if let rate = rate {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }
            
            // schedule a stop timer for when audio finishes playing
            self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(PlaybackViewController.stopAudio), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer, forMode: RunLoop.Mode.default)
        }
        
        do {
            try audioEngine.start()
        } catch {
            print(error.localizedDescription)
//            showAlert(Alerts.AudioEngineError, message: String(describing: error))
            return
        }
        
        // play the recording!
        audioPlayerNode.play()
    }
    
    // MARK: Connect List of Audio Nodes
    
    func connectAudioNodes(_ nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
    
    public func stopPlaying() {
        audioState = .notPlaying
        audioRecorder?.isMeteringEnabled = false
        audioPlayer?.isMeteringEnabled = false
        
        // This code is needed here so volume on playback is louder
        do {
            try audioRecordingSession.setCategory(.playback, mode: .default, options: .allowBluetooth)
        } catch {
            print("Failed to setCategory to .playback")
        }
        
        audioRecorder?.stop()
        audioPlayer?.stop()
    }
    
    //==================================================
    // MARK: - Record
    //==================================================
    
    public func record() {
        do {
            try audioRecordingSession.setCategory(.playAndRecord, mode: .default, options: .allowBluetooth)
            try audioRecordingSession.setActive(true)
            audioRecorder?.isMeteringEnabled = true
        } catch {
            print("Failed to record")
        }
        audioState = .recording
        audioRecorder?.record()
    }
}

//==================================================
// MARK: - AVAudioPlayer Delegate
//==================================================

extension AudioEngine: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioState = .notPlaying
        let playbackViewController = PlaybackViewController()
        playbackViewController.recordedAudioURL = audioRecorder?.url
        let recordingViewController = RecordingViewController()
        recordingViewController.navigationController?.pushViewController(playbackViewController, animated: true)
    }
    
}

//==================================================
// MARK: - AVAudioRecorder Delegate
//==================================================

extension AudioEngine: AVAudioRecorderDelegate {
    
}
