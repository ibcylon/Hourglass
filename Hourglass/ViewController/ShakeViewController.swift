//
//  ShakeViewController.swift
//  Hourglass
//
//  Created by Kanghos on 2021/11/22.
//

import UIKit

class ShakeViewController: UIViewController
{
    //Routine
    //테스트 용 데이터
    var data : [String] = ["렛품다운", "푸쉬업", "케이블 로우", "플라이", "프레스"]
    var setsInfo : [String] = ["1Set 10kg 15Reps", "2Set 15kg 15Reps", "3Set 15kg 15Reps"]
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var routineLabel: UILabel!
    @IBOutlet weak var shakeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel! {
        didSet {
            timerLabel.text = "00:00"
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
            
           collectionView.reloadData()
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
    
    private func uiSetting() {
        
        //Font
        timerLabel.font = UIFont.timerFont
        timerLabel.textColor = .black
        routineLabel.font = UIFont.contentTitle
        routineLabel.textColor = .white
        sceneTitleLabel.font = UIFont.sceneTitle
        sceneTitleLabel.textColor = .white
        workoutTitleLabel.font = UIFont.sceneTitle
        workoutTitleLabel.textColor = .black
        
        view.backgroundColor = UIColor.bgColor
        
        timerStateImage.tintColor = .black
        shakeButton.layer.cornerRadius = 10
        shakeButton.backgroundColor = UIColor.contentFortePink
        timerView.backgroundColor = .clear
        
        workoutView.backgroundColor = UIColor.contentPink
        workoutView.layer.cornerRadius = 10
        
        
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
        timeLeft = 5
        timerStateImage.image = UIImage(systemName: "play.fill")
    }
    
    @objc func fire(){
        print("Fire")
        
        timeLeft -= 1
        
        //시간
        timerLabel.text = timeLeft > 9 ? "00:\(timeLeft)" : "00:0\(timeLeft)"
        
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
        
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        
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
        
        if selectedRow == setsInfo.count - 1 {
            if selectedCellIndex == data.count - 1 {
                //1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                //2. UIalertAction 생성 : 버튼들..
                let ok = UIAlertAction(title: "iPhone Get!", style: .default)
                let ok2 = UIAlertAction(title: "iPhone Get2!", style: .default)
                
                let ipad = UIAlertAction(title: "ipad", style: .destructive)
                let watch = UIAlertAction(title: "watch", style: .cancel)
                
                //3. 1 + 2
                //.cancel is located bottom
                alert.addAction(ok)
                alert.addAction(ipad)
                alert.addAction(watch)
                alert.addAction(ok2)
                
                //4. Present Modal 형식
                present(alert, animated: true, completion: nil)
            } else {
            selectedCellIndex += 1
            }
           
        } else {
            workoutDataPicker.selectRow(selectedRow + 1, inComponent: 0, animated: true)
        }
            
    }
    
    @IBAction func timerButtonClicked(_ sender: UIButton) {
       
        if timer?.isValid == true {
            resetTimer()
        } else {
            startTimer()
        }
    }
}

//pickerView extension
extension ShakeViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return setsInfo.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return setsInfo[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: setsInfo[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    
}

extension ShakeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workoutCell", for: indexPath) as? WorkoutCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCell()
        cell.workoutTitle?.text = data[indexPath.row]
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
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    //collectionView.collectionViewLayout.item
    
}
