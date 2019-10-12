//
//  ExerciseListSectionHeaderView.swift
//  FlexFitnessApp
//
//  Created by Prem Pratap Singh on 12/10/19.
//  Copyright © 2019 xparrow. All rights reserved.
//

import UIKit

protocol ExerciseListSectionHeaderViewDelegate: class {
    func addSetTo(_ exercise: Exercise)
    func deleteExercise(_ exercise: Exercise)
}

class ExerciseListSectionHeaderView: UIView {
    weak var delegate: ExerciseListSectionHeaderViewDelegate!
    
    var sectionIndex = 0
    var exercise: Exercise!
    private var didConfigure = false
    
    private var titleLabel: UILabel!
    private var addSetButton: UIButton!
    private var deleteButton: UIButton!
    
    deinit {
        delegate = nil
        exercise = nil
    }
    
//    override func draw(_ rect: CGRect) {
//        guard !didConfigure else { return }
//        configureBackground()
//        configureLabel()
//        configureButton()
//        didConfigure = true
//    }
    
    func configure() {
        guard !didConfigure else { return }
        configureBackground()
        configureLabel()
        configureButton()
        didConfigure = true
    }
    
    private func configureBackground() {
        backgroundColor = .darkGray
    }
    
    private func configureLabel() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.text = "Exercise \(sectionIndex + 1)".localizedCapitalized
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configureButton() {
        deleteButton = UIButton(frame: .zero)
        let deleteImage = UIImage(named: "deleteIconWhite")
        deleteButton.setImage(deleteImage, for: .normal)
        deleteButton.addTarget(self, action: #selector(didTapOnDeleteButton), for: .touchUpInside)
        addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            deleteButton.widthAnchor.constraint(equalToConstant: 25),
            deleteButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        addSetButton = UIButton(frame: .zero)
        let addImage = UIImage(named: "addIconWhite")
        addSetButton.setImage(addImage, for: .normal)
        addSetButton.addTarget(self, action: #selector(didTapOnAddSetButton), for: .touchUpInside)
        addSubview(addSetButton)
        addSetButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addSetButton.centerYAnchor.constraint(equalTo: deleteButton.centerYAnchor, constant: 0),
            addSetButton.rightAnchor.constraint(equalTo: deleteButton.leftAnchor, constant: -10),
            addSetButton.widthAnchor.constraint(equalToConstant: 25),
            addSetButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    @objc private func didTapOnAddSetButton() {
        delegate.addSetTo(exercise)
    }
    
    @objc private func didTapOnDeleteButton() {
        delegate.deleteExercise(exercise)
    }
}
