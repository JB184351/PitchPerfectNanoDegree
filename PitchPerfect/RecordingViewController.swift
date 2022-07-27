//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Justin Bengtson on 7/23/22.
//

import UIKit

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
    }
    
    @objc func stopRecordingButtonAction(_ sender: AnyObject) {
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
        recordMessageLabel.text = NSLocalizedString("Tap To Record", comment: "User taps record button to start recording")
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
