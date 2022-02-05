//
//  WorkoutCollectionViewCell.swift
//  Hourglass
//
//  Created by Kanghos on 2021/11/25.
//

import UIKit

class WorkoutCollectionViewCell: UICollectionViewCell {

    static let identifer = "workoutCell"
    @IBOutlet weak var workoutView: UIView!
    @IBOutlet weak var workoutTitle: UILabel! {
        didSet {
            workoutTitle.text = "1"
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        uiSetting()
    }
    
    private func uiSetting(){
        
        //font
        workoutTitle?.font = UIFont.smallTitle
        workoutTitle.textColor = .black
        workoutView?.layer.cornerRadius = 10
    
        workoutView?.backgroundColor = UIColor.contentPink
    }
    
    func configureCell(){
        
    }

}
