//
//  ExerciseListViewModel.swift
//  FlexFitnessApp
//
//  Created by Prem Pratap Singh on 12/10/19.
//  Copyright © 2019 xparrow. All rights reserved.
//

import Foundation

class ExerciseListViewModel {
    var exercises = [Exercise]()
    
    func addNewExercise(completionHander: @escaping IndexCompletionHander) {
        let exercise = Exercise()
        exercise.id = UUID.init().uuidString
        exercises.append(exercise)
        completionHander(exercises.count - 1)
    }
    
    func deleteExercise(with id: String, completionHander: @escaping IndexCompletionHander) {
        let exerciseIndex = exercises.firstIndex { $0.id == id }
        if let index = exerciseIndex {
            exercises.remove(at: index)
            completionHander(index)
        }
    }
    
    func addNewExerciseSet(to exerciseId: String, completionHander: @escaping IndexPathCompletionHander) {
        let exerciseList = exercises.filter { $0.id == exerciseId }
        if let exerciseWithId = exerciseList.first {
            let exerciseSet = ExerciseSet()
            exerciseSet.id = UUID.init().uuidString
            exerciseSet.exerciseId = exerciseId
            exerciseWithId.sets.append(exerciseSet)
            
            let section = exercises.firstIndex { $0.id == exerciseId}
            let row = exerciseWithId.sets.count - 1
            completionHander(IndexPath(row: row, section: section!))
        } else {
            completionHander(nil)
        }
    }
    
    func arrangeSetsByType(for exerciseId: String, completionHander: @escaping IndexPathListCompletionHander) {
        let exerciseList = exercises.filter { $0.id == exerciseId }
        if let exerciseWithId = exerciseList.first {
            exerciseWithId.sets.sort { $0.type.rawValue < $1.type.rawValue }
            let section = exercises.firstIndex { $0.id == exerciseId}
            var indexPathList = [IndexPath]()
            for i in 0..<exerciseWithId.sets.count {
                indexPathList.append(IndexPath(row: i, section: section!))
            }
            completionHander(indexPathList)
        }
    }
    
    func deleteExerciseSet(_ set: ExerciseSet, completionHander: @escaping IndexPathCompletionHander) {
        let exerciseList = exercises.filter { $0.id == set.exerciseId }
        if let exerciseWithId = exerciseList.first {
            let setIndex = exerciseWithId.sets.firstIndex { $0.id == set.id }
            if let index = setIndex {
                exerciseWithId.sets.remove(at: index)
                let section = exercises.firstIndex { $0.id == exerciseWithId.id}
                completionHander(IndexPath(row: index, section: section!))
            } else {
                completionHander(nil)
            }
        } else {
            completionHander(nil)
        }
    }
}
