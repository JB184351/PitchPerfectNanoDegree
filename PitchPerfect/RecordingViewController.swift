//
//  RecordingViewController.swift
//  PitchPerfect
//
//  Created by Justin Bengtson on 7/23/22.
//

import UIKit
import AVFoundation

private enum Constants {
    static let stopRecordingImageWidth: CGFloat = 64.0
    static let stopRecordingImageHeight: CGFloat = 64.0
}

class RecordingViewController: UIViewController {
    
    private var recordingStackView = UIStackView()
    private var recordButton = UIButton()
    private var recordMessageLabel = UILabel()
    private var stopRecordingButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        recordButton.addTarget(self, action: #selector(recordButtonAction(_:)), for: .touchUpInside)
        stopRecordingButton.addTarget(self, action: #selector(stopRecordingButtonAction(_:)), for: .touchUpInside)
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
        setupUI()
    }
    
    // This will start recording the audio when selected
    @objc func recordButtonAction(_ sender: AnyObject) {
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        recordMessageLabel.text = NSLocalizedString("Recording In Progress", comment: "There is a current audio recordding")
        
        //        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        //        let recordingName = "recordedVoice.wav"
        //        let pathArray = [dirPath, recordingName]
        //        let filePath = URL(string: pathArray.joined(separator: "/"))
        //
        //        let session = AVAudioSession.sharedInstance()
        //        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        //
        //        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        //        audioRecorder.delegate = self
        //        audioRecorder.isMeteringEnabled = true
        //        audioRecorder.prepareToRecord()
        //        audioRecorder.record()
        
//        if let url = AudioRecordingManager.sharedInstance.createAudioRecordingURL() {
//            AudioEngine.sharedInstance.setupRecorder(fileURL: url)
//            AudioEngine.sharedInstance.record()
//        } else {
//            print("No url")
//        }
        
        if let url = AudioRecordingManager.sharedInstance.createAudioRecordingURL() {
            AudioEngine.sharedInstance.setupRecorder(fileURL: url) {
                AudioEngine.sharedInstance.record()
                let playbackViewController = PlaybackViewController()
                guard let audioRecordingURL = AudioRecordingManager.sharedInstance.createAudioRecordingURL() else { return }
                playbackViewController.recordedAudioURL = audioRecordingURL
                self.navigationController?.pushViewController(playbackViewController, animated: true)
            }
        }
    }
        
        @objc func stopRecordingButtonAction(_ sender: AnyObject) {
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
            recordMessageLabel.text = NSLocalizedString("Tap To Record", comment: "User taps record button to start recording")
            
            AudioEngine.sharedInstance.stop()
            
            let playbackViewController = PlaybackViewController()
            self.navigationController?.pushViewController(playbackViewController, animated: true)
        }
        
        func setupUI() {
            recordingStackView.axis = .vertical
            recordingStackView.alignment = .center
            recordingStackView.distribution = .fill
            recordingStackView.spacing = 8
            
            recordButton.sizeToFit()
            recordButton.setImage(UIImage(named: "RecordButton"), for: .normal)
            
            recordMessageLabel.text = NSLocalizedString("Tap To Record", comment: "User taps record button to start recording")
            recordMessageLabel.textColor = .black
            recordMessageLabel.textAlignment = .center
            
            stopRecordingButton.setImage(UIImage(named: "Stop"), for: .normal)
            
            view.addSubview(recordingStackView)
            recordingStackView.addArrangedSubview(recordButton)
            recordingStackView.addArrangedSubview(recordMessageLabel)
            recordingStackView.addArrangedSubview(stopRecordingButton)
            
            setupConstraints()
        }
        
        func setupConstraints() {
            recordingStackView.translatesAutoresizingMaskIntoConstraints = false
            stopRecordingButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate(
                [
                    recordingStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    recordingStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    stopRecordingButton.widthAnchor.constraint(equalToConstant: Constants.stopRecordingImageWidth),
                    stopRecordingButton.heightAnchor.constraint(equalToConstant: Constants.stopRecordingImageHeight)
                ]
            )
        }
        
    }
