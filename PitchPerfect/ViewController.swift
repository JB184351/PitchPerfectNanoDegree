//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Justin Bengtson on 7/23/22.
//

import UIKit

class ViewController: UIViewController {
    
    var recordButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        recordButton.addTarget(self, action: #selector(recordButtonAction(_:)), for: .touchUpInside)
        setupUI()
    }
    
    // This will start recording the audio when selected
    @objc func recordButtonAction(_ sender: UIButton) {
        print("We are recording")
    }
    
    func setupUI() {
        recordButton.backgroundColor = .green
        recordButton.sizeToFit()
        recordButton.setTitle(NSLocalizedString("Record", comment: "Record Button"), for: .normal)
        recordButton.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(recordButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        view.translatesAutoresizingMaskIntoConstraints = false
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        )
    }
    
}
