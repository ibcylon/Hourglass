//
//  RoutineTableViewCell.swift
//  Hourglass
//
//  Created by Kanghos on 2021/11/28.
//

import UIKit

class RoutineTableViewCell: UITableViewCell {

    static let identifier = "routineCell"
    @IBOutlet weak var workoutLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configUI(){
        self.backgroundColor = UIColor.contentPink
    }
    
    func configureCell(){
        self.backgroundColor = UIColor.contentPink
    }
    
}
