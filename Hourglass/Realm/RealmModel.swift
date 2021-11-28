

import Foundation
import RealmSwift

//1:1
class Sets : Object {
    @Persisted var setNumber : Int
    @Persisted var weight : Int
    @Persisted var reps : Int
    @Persisted var sec : Int
}
//1:다
//동일 운동에 대해서 다른 세트 정보를 가질 수 있게 변경해야함
class Workout : Object {
    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted var target
    @Persisted var target : String
    @Persisted var name : String
    @Persisted var SetsList : List<Sets>
    
}
//1:다
class Routine : Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var order : Int
    @Persisted var name : String
    @Persisted var workoutList : List<Workout>
}

