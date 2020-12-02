# FitnessTracker
iOS app written purely with Swift code. It doesn't use storyboards or xibs and have complex level of UITableView implementation.

![FitnessTracker-Demo](https://user-images.githubusercontent.com/27926337/100876311-39f17e80-34cd-11eb-8564-bfaeeab284f1.gif)

The app uses `MVVM design pattern` for,
1. Creationg and presentation of View, ViewControllers
2. Delegating business logic (data objects, logical calculations, etc) to the ViewModels
3. Data objects are defined as Models

The app uses a `UITableView` to present list of `Excercises` as `UITableViewCells`.Each excercise in the list contains a list of `WorkOuts`.
User could add/remove Excercies and Workouts at runtime, the UITableView is updated based on the updated list of Excercies and Workouts.

