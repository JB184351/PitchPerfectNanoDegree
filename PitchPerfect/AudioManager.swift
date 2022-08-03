//
//  AudioManager.swift
//  PitchPerfect
//
//  Created by Justin Bengtson on 7/30/22.
//

import Foundation
import AVFoundation

class AudioManager {
    
    //==================================================
    // MARK: - Public Properties
    //==================================================
    
    static let sharedInstance = AudioManager()
    
    public func createNewAudioRecording()  {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        guard let filePath = filePath else { return }
        
        AudioEngine.sharedInstance.setupRecorder(fileURL: filePath)
        AudioEngine.sharedInstance.record()
    }
    
    
}
