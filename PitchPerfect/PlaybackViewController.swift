//
//  PlaybackViewController.swift
//  PitchPerfect
//
//  Created by Justin Bengtson on 7/26/22.
//

import UIKit

class PlaybackViewController: UIViewController {

    var audioRecordingURL: URL!
    private var fastAndSlowPlaybackStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let slowPlaybackButton = UIButton()
        slowPlaybackButton.setImage(UIImage(named: "Slow"), for: .normal)
        
        let fastPlaybackButton = UIButton()
        fastPlaybackButton.setImage(UIImage(named: "Fast"), for: .normal)
        
        
        view.addSubview(fastAndSlowPlaybackStackView)
        fastAndSlowPlaybackStackView.addArrangedSubview(slowPlaybackButton)
        fastAndSlowPlaybackStackView.addArrangedSubview(fastPlaybackButton)
        
        fastAndSlowPlaybackStackView.axis = .horizontal
        fastAndSlowPlaybackStackView.alignment = .fill
        fastAndSlowPlaybackStackView.distribution = .fillEqually
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        fastAndSlowPlaybackStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fastAndSlowPlaybackStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            fastAndSlowPlaybackStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            fastAndSlowPlaybackStackView.topAnchor.constraint(equalTo: self.view.topAnchor),
            fastAndSlowPlaybackStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }

}
