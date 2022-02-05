//
//  RoutineDetailViewController.swift
//  Hourglass
//
//  Created by Kanghos on 2021/11/28.
//

import UIKit
import PanModal
import RealmSwift


enum DetailState : String {
    case add, edit
    
    var State : String {
        switch self {
        case .add:
            return "Add"
        case .edit:
            return "Edit"
        }
    }
    
}

protocol ModalWillDisappear {
    func refreshTrigger(_ modal : RoutineDetailViewController)
}

class RoutineDetailViewController: UIViewController {
    
    var delegate: ModalWillDisappear?
    
    var day : String = ""
    var workoutName : String = ""
    var routineName : String = ""
    var detailState : DetailState = .add
    
    let localRealm = try! Realm()
    var workout : Workout!
    var setsList : [Sets] = []
    var routine : Routine!
    
    //정규표현식 입력값
    let pattern = "^[^0-9]$"
    let maxLength = 14
    
    //var tasks : Results<Workout>!
    @IBOutlet weak var routineTextField: UITextField! {
        didSet {
            routineTextField.text = routineName
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var workoutNameTextField: UITextField! {
        didSet {
            workoutNameTextField.text = workoutName
        }
    }
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        workoutNameTextField.delegate = self
        routineTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: routineTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: workoutNameTextField)
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        uiSetting()
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(#function)
        if detailState == .add {
            routineTextField.becomeFirstResponder()
            
            
        } else {
            routine = localRealm.objects(Routine.self).filter("name contains[c] %@", routineName).first
            
            workout = routine.workoutList.filter("name contains[c] %@", workoutName).first
            
            for sets in workout.setsList {
                setsList.append(sets)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Trigger")
        delegate?.refreshTrigger(self)
        
    }
    
    func uiSetting(){
        routineTextField.backgroundColor = UIColor.bgColor
        routineTextField.font = UIFont.sceneTitle
        routineTextField.textColor = .white
        tableView.tableHeaderView?.backgroundColor = UIColor.bgColor
        tableView.backgroundColor = UIColor.bgColor
        
        routineTextField.attributedPlaceholder = NSAttributedString(string: "Input the Routine", attributes: [NSAttributedString.Key.foregroundColor : UIColor.contentPink])
        
        workoutNameTextField.attributedPlaceholder = NSAttributedString(string: "Input the Workout", attributes: [NSAttributedString.Key.foregroundColor : UIColor.contentPink])
        
        addButton.tintColor = UIColor.contentFortePink
        saveButton.backgroundColor = UIColor.contentFortePink
        saveButton.layer.cornerRadius = 25
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        
        add()
    }
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        if validateCheck() == true {
            
            save()
        }
        
    }
    
    func regexValidCheck(str : String) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: str, options : [], range: NSRange(location: 0, length: str.count)){
            return false
        } else {
            return true
        }
    }
    
    func validateCheck() -> Bool{
        
        //validation check
        if routineTextField.text?.isEmpty == true {
            
            showDefaultAlert(title: "Wait", message: "Insert the routine name !", actionTitle: "OK")
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            textFieldDidBeginEditing(routineTextField)
            return false
            
        }
        
        if workoutNameTextField.text?.isEmpty == true {
            
            showDefaultAlert(title: "Wait", message: "Insert the workout name !", actionTitle: "OK")
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return false
        }
        
        if setsList.count == 0 {
            showDefaultAlert(title: "Wait", message: "Insert the set at least 1 !", actionTitle: "OK")
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return false
        }
        
        for i in 0...setsList.count - 1 {
            guard let cell = (tableView.cellForRow(at: [0,i]) as? RoutineDetailTableViewCell)  else {
                return false
            }
            guard let sec = cell.secTextField.text,let reps = cell.repsTextField.text,let weight = cell.weightTextField.text else {
                showDefaultAlert(title: "Wait", message: "Empty value is not valid !", actionTitle: "OK")
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                print("input nil")
                return false
            }
            
            if sec.count * reps.count * weight.count == 0 {
                showDefaultAlert(title: "Wait", message: "Empty value is not valid !", actionTitle: "OK")
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                print("input empty")
                return false
            }
            
            guard let intSec = Int(sec),  let intWeight = Int(weight), let intReps = Int(reps) else {
                return false
            }
            if intSec * intReps * intWeight == 0 {
                showDefaultAlert(title: "Wait", message: "zero value is not valid !", actionTitle: "OK")
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                print("input 0")
                return false
            }
            
            if (regexValidCheck(str: sec) && regexValidCheck(str: reps) && regexValidCheck(str: weight)) == false {
                showDefaultAlert(title: "Wait", message: "Input the number only !", actionTitle: "OK")
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                print("regex valid error")
                return false
            }
            try! localRealm.write {
                setsList[i].weight = intWeight
                setsList[i].reps = intReps
                setsList[i].sec = intSec
            }
        }
        
        
        return true
    }
    
    
    
    func add(){
        let order = setsList.count + 1
        let weight = 10
        let sec = 60
        let reps = 12
        let set = Sets(order: order, weight: weight, reps: reps, sec: sec)
        
        setsList.append(set)
        tableView.reloadData()
    }
    
    func save(){
        
        
        
        print(detailState)
        if detailState == .add {
            
            
            
            
            guard let existRoutine = localRealm.objects(Routine.self).filter("name == %@",routineTextField.text!.uppercased()).first else {
                
                let routine = Routine(order: 1, name: routineTextField.text?.uppercased())
                let workout = Workout(name: workoutNameTextField.text!.uppercased())
                
                try! localRealm.write {
                    
                    for sets in setsList {
                        workout.setsList.append(sets)
                    }
                    
                    routine.workoutList.append(workout)
                    
                    localRealm.add(routine)
                }
                self.dismiss(animated: true, completion: nil)
                return
            }
            
            guard existRoutine.workoutList.filter("name == %@", workoutNameTextField.text!.uppercased()).first != nil else {
                
                try! localRealm.write {
                    
                    
                    let workout = Workout(name: workoutNameTextField.text!.uppercased())
                    for sets in setsList {
                        workout.setsList.append(sets)
                    }
                    
                    existRoutine.workoutList.append(workout)
                }
                self.dismiss(animated: true, completion: nil)
                return
            }
            
            //있는 경우 에러
            showDefaultAlert(title: "Wait", message: "There is already same workout in the routine !", actionTitle: "OK")
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            
            print("There is already same workout in the routine !")
            return
            
            
        } else {
            print(localRealm.objects(Routine.self))
            //1.동일 루틴에 동일 운동이 있을 경우 -> 에러
            //2.동일 루틴에 동일 운동이 없을 경우 -> 해당 루틴에 추가
            //3.동일 루틴이 없을 경우, -> 루틴 생성
            
            
            //만약 routine명이 같다면 추가하게만들기
            //같은 운동명은 등록 못하게 막을 것.
            //같은 루틴에 저장하려는 경우
            
            try! localRealm.write {
                workout.setsList.removeAll()
                
                for sets in setsList {
                    workout.setsList.append(sets)
                }
                routine.name = routineTextField.text?.uppercased()
                workout.name = workoutNameTextField.text!.uppercased()
                
                
            }
            
            //
            //            guard let existRoutine = localRealm.objects(Routine.self).filter("name == %@",routineTextField.text).first else {
            //
            //
            //
            //
            //            }
            //
            //            //같은 루틴에 워크 아웃이 중복일 경우 에러
            //            guard let existWorkout = existRoutine.workoutList.filter("name == %@", workoutNameTextField.text).first else {
            //
            //                try! localRealm.write {
            //
            //
            //                    for sets in setsList {
            //                        workout.setsList.append(sets)
            //                    }
            //                    workout.name = workoutNameTextField.text!
            //                    existRoutine.workoutList.append(workout)
            //                    existRoutine.name = routineTextField.text
            //
            //
            //                }
            //                self.dismiss(animated: true, completion: nil)
            //                return
            //            }
            //            //있는 경우 에러
            //            showDefaultAlert(title: "Wait", message: "There is already same workout in the routine !", actionTitle: "OK")
            //            UINotificationFeedbackGenerator().notificationOccurred(.error)
            //
            //            print("There is already same workout in the routine !")
            //            return
            //
            //
            //
            //
            //        }
            //
            //
            //
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}

extension RoutineDetailViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "routineDetailCell", for: indexPath) as? RoutineDetailTableViewCell else {
            return UITableViewCell()
        }
        let set = setsList[indexPath.row]
        cell.numberLabel.text = "\(set.order)"
        cell.weightTextField.text = "\(set.weight)"
        cell.repsTextField.text = "\(set.reps)"
        cell.secTextField.text = "\(set.sec)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            setsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension RoutineDetailViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //        let sb = UIStoryboard(name: "ModalSelection", bundle: nil)
        //        let vc = sb.instantiateViewController(withIdentifier: ModalViewController.identifier) as! ModalViewController
        //        self.presentPanModal(vc)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        
        if text.count >= maxLength && range.length == 0 && range.location < maxLength {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                if text.count > maxLength {
                    textField.resignFirstResponder()
                }
                
                if text.count >= maxLength {
                    let index = text.index(text.startIndex, offsetBy: maxLength)
                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                }
                
                
            }
        }
    }
    
    
  
    
    
}



extension RoutineDetailViewController: AlertPresentable {
    var presenter: UIViewController {
        return self
    }
}
