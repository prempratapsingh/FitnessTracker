//
//  ExerciseListTableViewCell.swift
//  FlexFitnessApp
//
//  Created by Prem Pratap Singh on 12/10/19.
//  Copyright © 2019 xparrow. All rights reserved.
//

import UIKit

protocol ExerciseListTableViewCellDelegate: class {
    func deleteExerciseSet(_ set: ExerciseSet)
    func arrangeSetsByType(for exerciseId: String)
}

class ExerciseListTableViewCell: UITableViewCell {
    static let cellIdentifier = "ExerciseListTableViewCell"
    weak var delegate: ExerciseListTableViewCellDelegate!

    var exerciseSet: ExerciseSet!
    var cellIndex = 0
    
    private var isEditModeOn = true
    private var isMockSet: Bool {
        return exerciseSet.isMock
    }
    
    private var titleLabel: UILabel!
    private var colorDotView: UIView!
    private var warmupButton: UIButton!
    private var regularButton: UIButton!
    private var saveButton: UIButton!
    private var cancelButton: UIButton!
    private var editButton: UIButton!
    private var deleteButton: UIButton!
    
    override func prepareForReuse() {
        cellIndex = 0
        isEditModeOn = false
        titleLabel.removeFromSuperview()
        colorDotView.removeFromSuperview()
        saveButton.removeFromSuperview()
        cancelButton.removeFromSuperview()
        warmupButton.removeFromSuperview()
        regularButton.removeFromSuperview()
        editButton.removeFromSuperview()
        deleteButton.removeFromSuperview()
    }
    
    func configure(with exerciseSet: ExerciseSet) {
        self.exerciseSet = exerciseSet
        isEditModeOn = isMockSet
        configureBackground()
        configureLabel()
        configureDotView()
        configureButton()
        configureState()
    }
    
    private func configureBackground() {
        backgroundColor = .white
    }
    
    private func configureLabel() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.text = "Set \(cellIndex + 1)".localizedCapitalized
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configureDotView() {
        colorDotView = UIView(frame: .zero)
        colorDotView.backgroundColor = exerciseSet.type == .warmUp ? .orange : .blue
        colorDotView.layer.cornerRadius = 8
        addSubview(colorDotView)
        colorDotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorDotView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 10),
            colorDotView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 0),
            colorDotView.widthAnchor.constraint(equalToConstant: 16),
            colorDotView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func configureButton() {
        warmupButton = UIButton(frame: .zero)
        warmupButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        warmupButton.setTitle("Warm-Up".localizedCapitalized, for: .normal)
        warmupButton.setTitleColor(.black, for: .normal)
        warmupButton.backgroundColor = .green
        warmupButton.layer.cornerRadius = 13
        warmupButton.layer.borderColor = UIColor.black.cgColor
        warmupButton.layer.borderWidth = 1
        warmupButton.addTarget(self, action: #selector(didTapOnWarmupButton), for: .touchUpInside)
        addSubview(warmupButton)
        warmupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            warmupButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            warmupButton.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
            warmupButton.widthAnchor.constraint(equalToConstant: 70),
            warmupButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        
        regularButton = UIButton(frame: .zero)
        regularButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        regularButton.setTitle("Regular".localizedCapitalized, for: .normal)
        regularButton.setTitleColor(.black, for: .normal)
        regularButton.backgroundColor = .gray
        regularButton.layer.cornerRadius = 13
        regularButton.layer.borderColor = UIColor.black.cgColor
        regularButton.layer.borderWidth = 1
        regularButton.addTarget(self, action: #selector(didTapOnRegularButton), for: .touchUpInside)
        addSubview(regularButton)
        regularButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            regularButton.topAnchor.constraint(equalTo: warmupButton.topAnchor, constant: 0),
            regularButton.leftAnchor.constraint(equalTo: warmupButton.rightAnchor, constant: 10),
            regularButton.widthAnchor.constraint(equalToConstant: 70),
            regularButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        
        saveButton = UIButton(frame: .zero)
        let addImage = UIImage(named: "saveIconGray")
        saveButton.setImage(addImage, for: .normal)
        saveButton.addTarget(self, action: #selector(didTapOnSaveButton), for: .touchUpInside)
        addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.leftAnchor.constraint(equalTo: colorDotView.rightAnchor, constant: 50),
            saveButton.centerYAnchor.constraint(equalTo: colorDotView.centerYAnchor, constant: 0),
            saveButton.widthAnchor.constraint(equalToConstant: 25),
            saveButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        cancelButton = UIButton(frame: .zero)
        let cancelImage = UIImage(named: "deleteIconGray")
        cancelButton.setImage(cancelImage, for: .normal)
        cancelButton.addTarget(self, action: #selector(didTapOnCancelButton), for: .touchUpInside)
        addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.leftAnchor.constraint(equalTo: saveButton.rightAnchor, constant: 10),
            cancelButton.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor, constant: 0),
            cancelButton.widthAnchor.constraint(equalToConstant: 25),
            cancelButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        editButton = UIButton(frame: .zero)
        let editImage = UIImage(named: "editIconGray")
        editButton.setImage(editImage, for: .normal)
        editButton.addTarget(self, action: #selector(didTapOnEditButton), for: .touchUpInside)
        addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.leftAnchor.constraint(equalTo: colorDotView.rightAnchor, constant: 50),
            editButton.centerYAnchor.constraint(equalTo: colorDotView.centerYAnchor, constant: 0),
            editButton.widthAnchor.constraint(equalToConstant: 25),
            editButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        deleteButton = UIButton(frame: .zero)
        let deleteImage = UIImage(named: "deleteIconGray")
        deleteButton.setImage(deleteImage, for: .normal)
        deleteButton.addTarget(self, action: #selector(didTapOnDeleteButton), for: .touchUpInside)
        addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.leftAnchor.constraint(equalTo: editButton.rightAnchor, constant: 10),
            deleteButton.centerYAnchor.constraint(equalTo: editButton.centerYAnchor, constant: 0),
            deleteButton.widthAnchor.constraint(equalToConstant: 25),
            deleteButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func configureState() {
        colorDotView.isHidden = isEditModeOn
        
        if !isMockSet {
            saveButton.removeFromSuperview()
            cancelButton.removeFromSuperview()
        } else {
            saveButton.isHidden = !isEditModeOn
            saveButton.isUserInteractionEnabled = isEditModeOn
            cancelButton.isHidden = !isEditModeOn
            cancelButton.isUserInteractionEnabled = isEditModeOn
            editButton.isHidden = true
            editButton.isUserInteractionEnabled = false
            deleteButton.isHidden = true
            deleteButton.isUserInteractionEnabled = false
        }
        
        warmupButton.isHidden = !isEditModeOn
        warmupButton.isUserInteractionEnabled = isEditModeOn
        regularButton.isHidden = !isEditModeOn
        regularButton.isUserInteractionEnabled = isEditModeOn
    }
    
    @objc private func didTapOnEditButton() {
        isEditModeOn = !isEditModeOn
        configureState()
        deleteButton.isUserInteractionEnabled = !isEditModeOn
        let image = UIImage(named: isEditModeOn ? "saveIconGray" : "editIconGray")
        editButton.setImage(image, for: .normal)
        
        if !isEditModeOn {
            delegate.arrangeSetsByType(for: exerciseSet.exerciseId)
        }
    }
    
    @objc private func didTapOnDeleteButton() {
        isEditModeOn = false
        delegate.deleteExerciseSet(exerciseSet)
    }
    
    @objc private func didTapOnSaveButton() {
        isEditModeOn = false
        exerciseSet.isMock = false
        configureState()
        editButton.isHidden = false
        editButton.isUserInteractionEnabled = true
        deleteButton.isHidden = false
        deleteButton.isUserInteractionEnabled = true
        
        delegate.arrangeSetsByType(for: exerciseSet.exerciseId)
    }
    
    @objc private func didTapOnCancelButton() {
        isEditModeOn = false
        delegate.deleteExerciseSet(exerciseSet)
    }
    
    @objc private func didTapOnWarmupButton() {
        exerciseSet.type = .warmUp
        regularButton.backgroundColor = .gray
        warmupButton.backgroundColor = .green
        colorDotView.backgroundColor = .orange
    }
    
    @objc private func didTapOnRegularButton() {
        exerciseSet.type = .regular
        regularButton.backgroundColor = .green
        warmupButton.backgroundColor = .gray
        colorDotView.backgroundColor = .blue
    }
}
