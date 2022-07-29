//
//  PlaybackViewController.swift
//  PitchPerfect
//
//  Created by Justin Bengtson on 7/26/22.
//

import UIKit

private enum Constants {
    static let playbackButtonImageWidth: CGFloat = 64.0
    static let playbackButtonImageHeight: CGFloat = 64.0
}

class PlaybackViewController: UIViewController {

    var audioRecordingURL: URL!
    private var allButtonsStackView = UIStackView()
    private var fastAndSlowPlaybackStackView = UIStackView()
    private var lowAndHighPitchPlaybackStackView = UIStackView()
    private var reverbAndEchoPlaybackStackView = UIStackView()
    private var playBackButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        //MARK: - Setup Buttons
        let slowPlaybackButton = UIButton()
        slowPlaybackButton.setImage(UIImage(named: "Slow"), for: .normal)
        
        let fastPlaybackButton = UIButton()
        fastPlaybackButton.setImage(UIImage(named: "Fast"), for: .normal)
        
        let squeakyPlaybackButton = UIButton()
        squeakyPlaybackButton.setImage(UIImage(named: "HighPitch"), for: .normal)
        
        
        let darthVaderPlaybackButton = UIButton()
        darthVaderPlaybackButton.setImage(UIImage(named: "LowPitch"), for: .normal)
        
        let reverbPlaybackButton = UIButton()
        reverbPlaybackButton.setImage(UIImage(named: "Reverb"), for: .normal)
        
        let echoPlaybackButton = UIButton()
        echoPlaybackButton.setImage(UIImage(named: "Echo"), for: .normal)
        
        playBackButton.setImage(UIImage(named: "Stop"), for: .normal)
        playBackButton.contentMode = .center
        playBackButton.imageView?.contentMode = .scaleAspectFit
        
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
