//
//  AudioEngine.swift
//  PitchPerfect
//
//  Created by Justin Bengtson on 7/30/22.
//

import Foundation
import AVFoundation

// Class is responsible for Recording and Playing an AudioRecording
class AudioEngine: NSObject {
    
    //==================================================
    // MARK: - Public Properties
    //==================================================
    
    static let sharedInstance = AudioEngine()
    public private(set) var audioState: PlayingState = .notPlaying

    //==================================================
    // MARK: - Private Properties
    //==================================================
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private let audioRecordingSession = AVAudioSession.sharedInstance()
    private var didFinishRecording: (() -> Void)?
    
    private override init() {}
    
    // Intializing audioRecorder here to make clear
    // when I'm initializing the audioRecorder and actually recording
    public func setupRecorder(fileURL: URL, completion: @escaping () -> Void) {
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: [:])
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
        } catch {
            if let err = error as Error? {
                print("AVAudioRecorder error: \(err.localizedDescription)")
                audioRecorder = nil
            }
        }
        
        didFinishRecording = completion
    }
    
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
    
    public func stop() {
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
}

//==================================================
// MARK: - AVAudioRecorder Delegate
//==================================================

extension AudioEngine: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        didFinishRecording?()
    }
}
