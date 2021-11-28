//
//  RoutineViewController.swift
//  Hourglass
//
//  Created by Kanghos on 2021/11/22.
//

import UIKit

class RoutineViewController: UIViewController {
    
    var data:[String] = ["gg"]
    
    static let identifier = "routineCell"
    
    @IBOutlet weak var sceneTitleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "RoutineTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: RoutineTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        uiSetting()
        
        // Do any additional setup after loading the view.
    }
    
    
    func uiSetting(){
        
        //font
        sceneTitleLabel.font = UIFont.sceneTitle
        
        view.backgroundColor = UIColor.bgColor
        tableView.backgroundColor = UIColor.bgColor
        tableView.tableHeaderView?.backgroundColor = UIColor.bgColor
        addButton.tintColor = UIColor.contentFortePink
    }
    
    

}

extension RoutineViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTableViewCell.identifier, for: indexPath) as? RoutineTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell()
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ㅎㅎ:"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "RoutineDetail", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RoutineDetailViewController")
        present(vc, animated: true, completion: nil)
    }
}
