//
//  ExerciseListViewController.swift
//  FlexFitnessApp
//
//  Created by Prem Pratap Singh on 12/10/19.
//  Copyright © 2019 xparrow. All rights reserved.
//

import UIKit

class ExerciseListViewController: UIViewController {
    var viewModel: ExerciseListViewModel!
    
    private var titleLabel: UILabel!
    private var addExerciseButton: UIButton!
    private var exerciseListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLabel()
        configureButton()
        configureTableView()
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func configureLabel() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.text = "John's exercise list".localizedCapitalized
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
        ])
    }
    
    private func configureButton() {
        addExerciseButton = UIButton(frame: .zero)
        addExerciseButton.backgroundColor = .black
        addExerciseButton.layer.cornerRadius = 15
        addExerciseButton.setTitle("Add Exercise", for: .normal)
        addExerciseButton.addTarget(self, action: #selector(didTapOnAddExerciseButton), for: .touchUpInside)
        view.addSubview(addExerciseButton)
        addExerciseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addExerciseButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 0),
            addExerciseButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            addExerciseButton.widthAnchor.constraint(equalToConstant: 120),
            addExerciseButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureTableView() {
        exerciseListTableView = UITableView(frame: .zero, style: .grouped)
        exerciseListTableView.backgroundColor = .white
        exerciseListTableView.separatorStyle = .none
        exerciseListTableView.allowsSelection = false
        exerciseListTableView.rowHeight = UITableView.automaticDimension
        exerciseListTableView.estimatedRowHeight = 75
        exerciseListTableView.dataSource = self
        exerciseListTableView.delegate = self
        exerciseListTableView.register(ExerciseListTableViewCell.self, forCellReuseIdentifier: ExerciseListTableViewCell.cellIdentifier)
        view.addSubview(exerciseListTableView)
        exerciseListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            exerciseListTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            exerciseListTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            exerciseListTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            exerciseListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func didTapOnAddExerciseButton() {
        viewModel.addNewExercise(completionHander: {[weak self] sectionIndex in
            guard let strongSelf = self else { return }
            strongSelf.exerciseListTableView.beginUpdates()
            strongSelf.exerciseListTableView.insertSections([sectionIndex], with: .fade)
            strongSelf.exerciseListTableView.endUpdates()
        })
    }
}

extension ExerciseListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.exercises.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let exercise = viewModel.exercises[section]
        return exercise.sets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseListTableViewCell.cellIdentifier, for: indexPath) as? ExerciseListTableViewCell {
            let exercise = viewModel.exercises[indexPath.section]
            cell.delegate = self
            cell.cellIndex = indexPath.row
            cell.configure(with: exercise.sets[indexPath.row])
            return cell
        }
        return ExerciseListTableViewCell()
    }
}

extension ExerciseListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ExerciseListSectionHeaderView(frame: .zero)
        headerView.frame.size = CGSize(width: exerciseListTableView.bounds.width, height: 50)
        headerView.delegate = self
        headerView.sectionIndex = section
        headerView.exercise = viewModel.exercises[section]
        headerView.configure()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension ExerciseListViewController: ExerciseListSectionHeaderViewDelegate {
    func addSetTo(_ exercise: Exercise) {
        viewModel.addNewExerciseSet(to: exercise.id, completionHander: { [weak self] indexPath in
            guard let strongSelf = self,
                let path = indexPath else { return }
            strongSelf.exerciseListTableView.beginUpdates()
            strongSelf.exerciseListTableView.insertRows(at: [path], with: .fade)
            strongSelf.exerciseListTableView.endUpdates()
        })
    }
    
    func deleteExercise(_ exercise: Exercise) {
        viewModel.deleteExercise(with: exercise.id, completionHander: { [weak self] sectionIndex in
            guard let strongSelf = self else { return }
            UIView.setAnimationsEnabled(false)
            strongSelf.exerciseListTableView.beginUpdates()
            strongSelf.exerciseListTableView.deleteSections([sectionIndex], with: .fade)
            strongSelf.exerciseListTableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            
            let totalSections = strongSelf.exerciseListTableView.numberOfSections
            for i in 0..<totalSections {
                strongSelf.exerciseListTableView.reloadSections([i], with: .none)
            }
        })
    }
}

extension ExerciseListViewController: ExerciseListTableViewCellDelegate {
    func deleteExerciseSet(_ set: ExerciseSet) {
        viewModel.deleteExerciseSet(set, completionHander: { [weak self] indexPath in
            guard let strongSelf = self,
                let path = indexPath else { return }
            strongSelf.exerciseListTableView.beginUpdates()
            strongSelf.exerciseListTableView.deleteRows(at: [path], with: .fade)
            strongSelf.exerciseListTableView.endUpdates()
        })
    }
    
    func arrangeSetsByType(for exerciseId: String) {
        viewModel.arrangeSetsByType(for: exerciseId, completionHander: { [weak self] indexPathList in
            guard let strongSelf = self else { return }
            strongSelf.exerciseListTableView.beginUpdates()
            strongSelf.exerciseListTableView.reloadRows(at: indexPathList, with: .none)
            strongSelf.exerciseListTableView.endUpdates()
        })
    }
}
