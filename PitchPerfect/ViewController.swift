//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Justin Bengtson on 7/23/22.
//

import UIKit

class ViewController: UIViewController {
    
    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    func setupUI() {
        button.backgroundColor = .green
        button.sizeToFit()
        button.setTitle(NSLocalizedString("Record", comment: "Record Button"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(button)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        view.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate(
            [
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        )
    }
    
    
}

