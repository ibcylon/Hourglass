//
//  ShakeViewController.swift
//  Hourglass
//
//  Created by Kanghos on 2021/11/22.
//

import UIKit
import RealmSwift

class ShakeViewController: UIViewController
{
    //Routine
    var routineIndex : Int = 0
    let localRealm = try! Realm()
    var tasks : Results<Routine>!
    
    //테스트 용 데이터
    var routine : Routine?

    var setsInfo : [String] = []
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var routineLabel: UILabel!
    @IBOutlet weak var shakeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel! {
        didSet {
            timerLabel.text = "00 : 00"
        }
    }
    
    @IBOutlet weak var timerStateImage: UIImageView!
    @IBOutlet weak var workoutView: UIView!
    @IBOutlet weak var workoutDataPicker: UIPickerView!
    @IBOutlet weak var workoutTitleLabel: UILabel!
    @IBOutlet weak var sceneTitleLabel: UILabel!
    
    var timer: Timer?
    var timeLeft: Int = 5
    
    var selectedCellIndex = 0 {
        
        didSet {
            
            collectionView.collectionViewLayout.invalidateLayout()//reloadData()
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //motionResponder 등록
        self.becomeFirstResponder()
        
        uiSetting()
        
        workoutDataPicker.delegate = self
        workoutDataPicker.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nibName = UINib(nibName: "WorkoutCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: WorkoutCollectionViewCell.identifer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        refreshRoutine()
        
        //        tasks = localRealm.objects(Routine.self)
        //        guard let currentRoutine = tasks.first else {
        //            showDefaultAlert(title: "Wait", message: "Make the routine first !", actionTitle: "OK")
        //
        //
        //            return
        //        }
        //        routine = currentRoutine
        //        //print(routine.workoutList.first)
        //        collectionView.reloadData()
        //        workoutDataPicker.reloadAllComponents()
        //
        //
        //        routineLabel.text = currentRoutine.name
        
    }
    
    private func uiSetting() {
        
        //Font
        timerLabel.font = UIFont.timerFont
        timerLabel.textColor = .black
        routineLabel.font = UIFont.contentTitle
        routineLabel.textColor = .white
        sceneTitleLabel.font = UIFont.sceneTitle
        sceneTitleLabel.textColor = .white
        
        workoutTitleLabel.font = UIFont.sectionTitle
        workoutTitleLabel.textColor = .black
        
        view.backgroundColor = UIColor.bgColor
        
        timerStateImage.tintColor = .black
        shakeButton.layer.cornerRadius = 15
        shakeButton.backgroundColor = UIColor.contentFortePink
        timerView.backgroundColor = .clear
        
        workoutView.backgroundColor = UIColor.contentPink
        workoutView.layer.cornerRadius = 15
        
        
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        timerStateImage.image = UIImage(systemName: "pause")
        
    }
    
    func stopTimer(){
        timer?.invalidate()
        timerStateImage.image = UIImage(systemName: "play.fill")
        
    }
    
    func resetTimer(){
        timer?.invalidate()
        timeLeft = routine?.workoutList[selectedCellIndex].setsList[workoutDataPicker.selectedRow(inComponent: 0)].sec ?? 0
        timerStateImage.image = UIImage(systemName: "play.fill")
    }
    
    private func secondsToString(sec: Double) -> String {
        guard sec.isNaN == false else { return "00 : 00" }
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d : %02d", min, seconds)
    }
    
    @objc func fire(){
        print("Fire")
        
        timeLeft -= 1
        
        //시간
        timerLabel.text = secondsToString(sec: Double(timeLeft))
        
        if timeLeft < 1 {
            
            timer?.invalidate()
            print("time Out!")
            resetTimer()
            updateWorkoutInfo()
        }
    }
    
    func hapticGenerator(){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionBegan(motion, with: event)
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        
        guard tasks.first != nil else {
            showDefaultAlert(title: "Wait", message: "Make the routine first !", actionTitle: "OK")
            
            
            return
        }
        
        if motion == .motionShake {
            hapticGenerator()
            //self.view.backgroundColor = .systemOrange
            if timer?.isValid != true {
                startTimer()
            } else {
                print("Already started!")
                stopTimer()
            }
            
            print("Why are you shaking me?")
        }
    }
    
    
    /// 타이머가 만료되면 다음 세트 또는 다음 운동으로 갱신한다.
    /// 피커뷰를 다음 세트로 갱신한다. 만약 마지막 세트라면, 다음 운동으로 변경하고 첫 세트로 변경한다.
    /// 마지막 운동의 마지막 세트라면 운동이 완료되었다는 모달을 출력한다.
    ///
    func updateWorkoutInfo(){
        
        print(selectedCellIndex)
        
        let selectedRow = workoutDataPicker.selectedRow(inComponent: 0)
        
        if selectedRow == (routine?.workoutList[selectedCellIndex].setsList.count ?? 1) - 1 {
            
            //마지막 운동이면
            if selectedCellIndex == (routine?.workoutList.count ?? 1) - 1 {
                showDefaultAlert(title: "🎉🎉", message: "🏅 Good Job !", actionTitle: "OK")
                
            } else {
                //셀 변경 및 workoutview 리로드
                selectedCellIndex += 1
                collectionView.scrollToItem(at: [0,selectedCellIndex], at: .centeredVertically, animated: true)
                
            }
            
        } else {
            workoutDataPicker.selectRow(selectedRow + 1, inComponent: 0, animated: true)
        }
        
    }
    
    func refreshRoutine(){
        tasks = localRealm.objects(Routine.self)
        guard tasks.first != nil else {
            showDefaultAlert(title: "Wait", message: "Make the routine first !", actionTitle: "OK")
          
            
            return
        }
        
        if routineIndex >= tasks.count {
            routineIndex = 0
        }
        
        let selectedRoutine = tasks[routineIndex]
        routine = selectedRoutine
        collectionView.reloadData()
        
        routineLabel.text = selectedRoutine.name
        
        refreshWorkout()
        
        selectedCellIndex = 0
        //data = routine.workoutList
        
    }
    
    func refreshWorkout(){
        workoutDataPicker.reloadAllComponents()
        
        workoutTitleLabel.text = routine?.workoutList[selectedCellIndex].name
        
        timeLeft = routine?.workoutList[selectedCellIndex].setsList[0].sec ?? 60
    }
    
    @IBAction func timerButtonClicked(_ sender: UIButton) {
        
        guard tasks.first != nil else {
            showDefaultAlert(title: "Wait", message: "Make the routine first !", actionTitle: "OK")
            
           return
        }
        
        if timer?.isValid == true {
            resetTimer()
        } else {
            startTimer()
        }
    }
    
    @IBAction func leftRoutineButtonClicked(_ sender: UIButton) {
        if routineIndex > 0 {
            routineIndex -= 1
            refreshRoutine()
        }
    }
    
    @IBAction func rightRoutineButtonClicked(_ sender: UIButton) {
        if routineIndex < tasks.count - 1 {
            routineIndex += 1
            refreshRoutine()
        }
    }
    
}

//pickerView extension
extension ShakeViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return routine?.workoutList[selectedCellIndex].setsList.count ?? 0 // setsInfo.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let reps = routine?.workoutList[selectedCellIndex].setsList[row].reps,
              let sec = routine?.workoutList[selectedCellIndex].setsList[row].sec,
              let weight = routine?.workoutList[selectedCellIndex].setsList[row].weight,
              let order = routine?.workoutList[selectedCellIndex].setsList[row].order else {
                  return ""
              }
        
        return  "\(order)Set \(weight)kg \(reps)reps \(sec)sec"
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let reps = routine?.workoutList[selectedCellIndex].setsList[row].reps,
              let sec = routine?.workoutList[selectedCellIndex].setsList[row].sec,
              let weight = routine?.workoutList[selectedCellIndex].setsList[row].weight,
              let order = routine?.workoutList[selectedCellIndex].setsList[row].order else {
                  return nil
              }
        
        return NSAttributedString(string: "\(order)Set \(weight)kg \(reps)reps \(sec)sec", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    
}

extension ShakeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return routine?.workoutList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workoutCell", for: indexPath) as? WorkoutCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell()
        cell.workoutTitle?.text = routine?.workoutList[indexPath.row].name // data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        //        //let padding = 10
        let height = collectionView.frame.height
        //        //let itemsPerColumn = 3
        
        if indexPath.row == selectedCellIndex {
            print("\(selectedCellIndex) is selected index")
            
            return CGSize(width: width, height: floor(height / 2.0))
        } else {
            return CGSize(width: width, height: floor(height / 5.0))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCellIndex = indexPath.row
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        print("[\(selectedCellIndex)]Cell clicked!")
        refreshWorkout()
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    //collectionView.collectionViewLayout.item
    
}

extension ShakeViewController: AlertPresentable {
    var presenter: UIViewController {
        return self
    }
}
