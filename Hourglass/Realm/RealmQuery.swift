//
//  RealmQuery.swift
//  Hourglass
//
//  Created by Kanghos on 2021/11/28.
//

import UIKit
import RealmSwift


extension UIViewController {
    
    func getRoutineByName(routineName : String) -> Routine? {
        let localRealm = try! Realm()
        let routine = localRealm.objects(Routine.self).where {
            $0.name.equals(routineName)
        }.first
        
        
        return routine
    }
    func getWorkoutNameList() -> Results<WorkoutName>{
        let localRealm = try! Realm()
        let workoutLists = localRealm.objects(WorkoutName.self)
        
        return workoutLists
    }
    
   
    func getWorkout(routineName : String, workoutName : String) -> Workout? {
        let localRealm = try! Realm()
        let routine = localRealm.objects(Routine.self).where { $0.name.equals(routineName) }.first
        let workoutList = routine?.workoutList  //as? Results<List<Workout>>
        let workout = workoutList?.where { $0.name.equals(workoutName)}.first
        
        return workout
    }
    
//    func getSetByIndex(setList : Results<Sets>, index : Int) -> ResultsSets{
//        let localRealm = try! Realm()
//        let
//    }
    
    func addSet(workout : Workout, set : Sets){
        let localRealm = try! Realm()
        
        try! localRealm.write {
            workout.setsList.append(set)
        }
    }
}
//    func searchQueryFromMemo(text: String) -> Results<Memo> {
//
//        let localRealm = try! Realm()
//        //검색어가 제목과 본문에 있는 것을 필터링하여 반환
//        let search = localRealm.objects(Memo.self).filter("title CONTAINS[c] '\(text)' OR content CONTAINS[c] '\(text)'")
//        print("search : \(search)")
//
//        return search
//    }
//
//    func getAllMemo() -> Results<Memo> {
//
//        let localRealm = try! Realm()
//        let memos = localRealm.objects(Memo.self).sorted(byKeyPath: "writeDate", ascending: true)
//
//        return memos
//    }
//
//    func getAllCount() -> Int {
//
//        let localRealm = try! Realm()
//        let count = localRealm.objects(Memo.self).count
//
//        return count
//    }
//
//
//
//    func deleteQueryMemo(task:Memo){
//        let localRealm = try! Realm()
//
//        try! localRealm.write {
//            localRealm.delete(task)
//        }
//    }
//
//    func updateQueryFixedState(task:Memo){
//        let localRealm = try! Realm()
//
//        try! localRealm.write {
//            task.fixed = !task.fixed
//        }
//    }
//
////    func updateQueryMemo(content:String){
////        let localRealm = try! Realm()
////    }
//}

