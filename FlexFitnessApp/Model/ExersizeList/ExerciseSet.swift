//
//  ExerciseSet.swift
//  FlexFitnessApp
//
//  Created by Prem Pratap Singh on 12/10/19.
//  Copyright © 2019 xparrow. All rights reserved.
//

import Foundation

enum ExerciseSetType: Int {
    case warmUp = 0
    case regular = 1
}

class ExerciseSet {
    var id = ""
    var exerciseId = ""
    var type: ExerciseSetType = .warmUp
    var isMock = true
}
