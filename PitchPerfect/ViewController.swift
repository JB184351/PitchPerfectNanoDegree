//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Justin Bengtson on 7/23/22.
//

import UIKit

class ViewController: UIViewController {
    
    var recordingStackView = UIStackView()
    var recordButton = UIButton()
    var recordMessageLabel = UILabel()
    var stopRecordingButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        recordButton.addTarget(self, action: #selector(recordButtonAction(_:)), for: .touchUpInside)
        stopRecordingButton.addTarget(self, action: #selector(stopRecordingButtonAction(_:)), for: .touchUpInside)
        setupUI()
    }
    
    // This will start recording the audio when selected
    @objc func recordButtonAction(_ sender: AnyObject) {
        print("We are recording")
    }
    
    @objc func stopRecordingButtonAction(_ sender: AnyObject) {
        print("Stop recording")
    }
    
    func setupUI() {
        recordingStackView.axis = .vertical
        recordingStackView.alignment = .fill
        recordingStackView.distribution = .fillEqually
        recordingStackView.spacing = 8
        
        recordButton.backgroundColor = .green
        recordButton.sizeToFit()
        recordButton.setTitle(NSLocalizedString("Record", comment: "Record Button"), for: .normal)
        recordButton.setTitleColor(.systemBlue, for: .normal)
        
        recordMessageLabel.text = NSLocalizedString("Tap To Record", comment: "User taps record button to start recording")
        recordMessageLabel.textColor = .black
        recordMessageLabel.textAlignment = .center
        
        stopRecordingButton.setTitle(NSLocalizedString("Stop Recording", comment: "App Stops Recording Audio When Pressed"), for: .normal)
        stopRecordingButton.setTitleColor(.blue, for: .normal)
        
        view.addSubview(recordingStackView)
        recordingStackView.addArrangedSubview(recordButton)
        recordingStackView.addArrangedSubview(recordMessageLabel)
        recordingStackView.addArrangedSubview(stopRecordingButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        recordingStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                recordingStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                recordingStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        )
    }
    
}
