//
//  AudioRecordingManager.swift
//  PitchPerfect
//
//  Created by Justin Bengtson on 8/4/22.
//

import Foundation

class AudioRecordingManager {
    
    static let sharedInstance = AudioRecordingManager()
    
    public func createAudioRecordingURL() -> URL? {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        guard let filePath = URL(string: pathArray.joined(separator: "/")) else { return nil }
        
        return filePath
    }
    
    public func createAudioRecording(){
        guard let audioRecordingURL = createAudioRecordingURL() else { return }
        AudioEngine.sharedInstance.setupRecorder(fileURL: audioRecordingURL)
        AudioEngine.sharedInstance.record()
    }
}
