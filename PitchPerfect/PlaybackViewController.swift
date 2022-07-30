//
//  PlaybackViewController.swift
//  PitchPerfect
//
//  Created by Justin Bengtson on 7/26/22.
//

import UIKit
import AVFoundation

private enum Constants {
    static let playbackButtonImageWidth: CGFloat = 64.0
    static let playbackButtonImageHeight: CGFloat = 64.0
}

class PlaybackViewController: UIViewController {

    var allButtonsStackView = UIStackView()
    var fastAndSlowPlaybackStackView = UIStackView()
    var lowAndHighPitchPlaybackStackView = UIStackView()
    var reverbAndEchoPlaybackStackView = UIStackView()
    
    let playBackButton = UIButton()
    let slowPlaybackButton = UIButton()
    let fastPlaybackButton = UIButton()
    let squeakyPlaybackButton = UIButton()
    let darthVaderPlaybackButton = UIButton()
    let reverbPlaybackButton = UIButton()
    let echoPlaybackButton = UIButton()
    
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

    enum ButtonType: Int {
        case slow = 0, fast = 1, chipmunk = 2, vader = 3, echo = 4, reverb = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBackButton.addTarget(self, action: #selector(playSoundForButton(_:)), for: .touchUpInside)
        setupAudio()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        //MARK: - Setup Buttons
        slowPlaybackButton.setImage(UIImage(named: "Slow"), for: .normal)
        slowPlaybackButton.addTarget(self, action: #selector(playSoundForButton(_:)), for: .touchUpInside)
        slowPlaybackButton.tag = 0
        
        fastPlaybackButton.setImage(UIImage(named: "Fast"), for: .normal)
        fastPlaybackButton.addTarget(self, action: #selector(playSoundForButton(_:)), for: .touchUpInside)
        fastPlaybackButton.tag = 1
        
        squeakyPlaybackButton.setImage(UIImage(named: "HighPitch"), for: .normal)
        squeakyPlaybackButton.addTarget(self, action: #selector(playSoundForButton(_:)), for: .touchUpInside)
        squeakyPlaybackButton.tag = 2
        
        darthVaderPlaybackButton.setImage(UIImage(named: "LowPitch"), for: .normal)
        darthVaderPlaybackButton.addTarget(self, action: #selector(playSoundForButton(_:)), for: .touchUpInside)
        darthVaderPlaybackButton.tag = 3
        
        reverbPlaybackButton.setImage(UIImage(named: "Reverb"), for: .normal)
        reverbPlaybackButton.addTarget(self, action: #selector(playSoundForButton(_:)), for: .touchUpInside)
        reverbPlaybackButton.tag = 4
        
        echoPlaybackButton.setImage(UIImage(named: "Echo"), for: .normal)
        echoPlaybackButton.addTarget(self, action: #selector(playSoundForButton(_:)), for: .touchUpInside)
        echoPlaybackButton.tag = 5
        
        playBackButton.setImage(UIImage(named: "Stop"), for: .normal)
        playBackButton.contentMode = .center
        playBackButton.imageView?.contentMode = .scaleAspectFit
        playBackButton.addTarget(self, action: #selector(playBackButtonAction(_:)), for: .touchUpInside)
        
        //MARK: - Setup Stack Views
        allButtonsStackView.axis = .vertical
        allButtonsStackView.distribution = .fillEqually
        allButtonsStackView.alignment = .fill
        
        fastAndSlowPlaybackStackView.axis = .horizontal
        fastAndSlowPlaybackStackView.alignment = .fill
        fastAndSlowPlaybackStackView.distribution = .fillEqually
        
        lowAndHighPitchPlaybackStackView.axis = .horizontal
        lowAndHighPitchPlaybackStackView.alignment = .fill
        lowAndHighPitchPlaybackStackView.distribution = .fillEqually
        
        reverbAndEchoPlaybackStackView.axis = .horizontal
        reverbAndEchoPlaybackStackView.alignment = .fill
        reverbAndEchoPlaybackStackView.distribution = .fillEqually
        
        view.addSubview(allButtonsStackView)
        allButtonsStackView.addArrangedSubview(fastAndSlowPlaybackStackView)
        allButtonsStackView.addArrangedSubview(lowAndHighPitchPlaybackStackView)
        allButtonsStackView.addArrangedSubview(reverbAndEchoPlaybackStackView)
        allButtonsStackView.addArrangedSubview(playBackButton)
        
        fastAndSlowPlaybackStackView.addArrangedSubview(slowPlaybackButton)
        fastAndSlowPlaybackStackView.addArrangedSubview(fastPlaybackButton)
        
        lowAndHighPitchPlaybackStackView.addArrangedSubview(squeakyPlaybackButton)
        lowAndHighPitchPlaybackStackView.addArrangedSubview(darthVaderPlaybackButton)
        
        reverbAndEchoPlaybackStackView.addArrangedSubview(echoPlaybackButton)
        reverbAndEchoPlaybackStackView.addArrangedSubview(reverbPlaybackButton)
        
        setupConstraints()
    }
    
    @objc func playSoundForButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }

        configureUI(.playing)
    }
    
    @objc func playBackButtonAction(_ sender: UIButton) {
        stopAudio()
        configureUI(.notPlaying)
    }
    
    //MARK: - Add Constraints
    private func setupConstraints() {
        allButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        playBackButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            allButtonsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            allButtonsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            allButtonsStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32),
            allButtonsStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8),
            playBackButton.widthAnchor.constraint(equalToConstant: Constants.playbackButtonImageWidth),
            playBackButton.heightAnchor.constraint(equalToConstant: Constants.playbackButtonImageHeight)
        ])
    }

}
