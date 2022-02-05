

import Foundation
import RealmSwift

//1:1
class Sets : Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var order : Int
    @Persisted var weight : Int
    @Persisted var reps : Int
    @Persisted var sec : Int
    
    convenience init(order: Int, weight: Int, reps : Int, sec : Int) {
        self.init()
        
        self.order = order
        self.weight = weight
        self.reps = reps
        self.sec = sec
    }
}



//1:다
//동일 운동에 대해서 다른 세트 정보를 가질 수 있게 변경해야함
class Workout : Object {
    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted var target
    @Persisted var name : String
    @Persisted var setsList : List<Sets>
    
    convenience init(name : String, setsList : List<Sets>){
        self.init()
        
        self.name = name
        self.setsList = setsList
    }
    
    convenience init(name : String){
        self.init()
        
        self.name = name
    }
}

//1:다
class Routine : Object {
    //@Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var order : Int
    @Persisted var name : String?
    @Persisted var workoutList : List<Workout>
    
    convenience init(order : Int, name : String?, workoutList : List<Workout>){
        self.init()
        
        self.order = order
        self.name = name
        self.workoutList = workoutList
    }
    
    convenience init(order : Int, name : String?){
        self.init()
        self.order = order
        self.name = name
    }
    
}

class WorkoutName : Object {
    @Persisted var name : String
}
