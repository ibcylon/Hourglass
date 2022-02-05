//
//  ModalViewController.swift
//  Hourglass
//
//  Created by Kanghos on 2021/12/03.
//

import UIKit
import PanModal
import RealmSwift

class ModalViewController: UIViewController {
    
    static let identifier = "ModalViewController"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data:[String] = []
    
    let localRealm = try! Realm()
    var tasks : Results<WorkoutName>! {
        didSet {
            tasks = getWorkoutNameList()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tasks = getWorkoutNameList()
        // Do any additional setup after loading the view.
    }
    

  

}

extension ModalViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks.count + 1//추가
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "modalCell", for: indexPath) as? ModalCollectionViewCell else { return UICollectionViewCell() }
        
        //cell.workoutLabel.text = tasks
        return cell
    }
    
    
    
}



extension ModalViewController : PanModalPresentable {
    var panScrollable: UIScrollView? {
        return collectionView
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(UIScreen.main.bounds.height/2)
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(0)
    }
}
