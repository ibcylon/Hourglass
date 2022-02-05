//
//  RoutineViewController.swift
//  Hourglass
//
//  Created by Kanghos on 2021/11/22.
//

import UIKit
import RealmSwift

class RoutineViewController: UIViewController {
    
    let localRealm = try! Realm()
    var task  : Results<Routine>!
    
    var routineList : [Routine]!
    var data:[String] = ["Day 1", "Day 2", "Day 3"]
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(#function + "Routine View")
        task = localRealm.objects(Routine.self)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print(#function)
    }
    override func viewDidDisappear(_ animated: Bool) {
        print(#function)
    }
    func uiSetting(){
        
        //font
        sceneTitleLabel.font = UIFont.sceneTitle
        sceneTitleLabel.textColor = .white
        tableView.sectionIndexColor = .white
        
        
        view.backgroundColor = UIColor.bgColor
        tableView.backgroundColor = UIColor.bgColor
        tableView.tableHeaderView?.backgroundColor = UIColor.bgColor
        addButton.tintColor = UIColor.contentFortePink
    }
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        let sb = UIStoryboard(name: "RoutineDetail", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RoutineDetailViewController") as! RoutineDetailViewController
        vc.detailState = .add
        vc.delegate = self
        present(vc, animated: true) {
        }
    }
    
}

extension RoutineViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task[section].workoutList.count//data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTableViewCell.identifier, for: indexPath) as? RoutineTableViewCell else {
            return UITableViewCell()
        }
        let row = task[indexPath.section].workoutList[indexPath.row]
        cell.workoutLabel.text = row.name
        //cell.configureCell()
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return task.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return task[section].name?.localized
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.sectionTitle
            header.textLabel?.textColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "RoutineDetail", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "RoutineDetailViewController") as! RoutineDetailViewController
        
        vc.detailState = .edit
        vc.routineName = tableView.headerView(forSection: indexPath.section)?.textLabel?.text ?? ""
        let cell = tableView.cellForRow(at: indexPath) as! RoutineTableViewCell
        vc.workoutName = cell.workoutLabel?.text ?? ""
        vc.delegate = self
        
        
        present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            //루틴에서 선택된 workout을 찾아서 삭제한다.
            //subscript로 바로 선택되게 리팩토링
            if let routine = task?[indexPath.section] {
               
                //Workout이 1개일 경우, Routine 삭제
                if routine.workoutList.count == 1 {
                    try! localRealm.write {
                        localRealm.delete(routine)
                    }
                    
                } else {
                    //optional type이 아니기 때문에 guard 처리 불가능
                    if indexPath.row < routine.workoutList.count {
                        let item = routine.workoutList[indexPath.row]
                        try! localRealm.write {
                            localRealm.delete(item)
                        }
                    }
                }
            }
            tableView.reloadData()
        }
        
    }
    
    
}

extension RoutineViewController : ModalWillDisappear {
    func refreshTrigger(_ modal: RoutineDetailViewController) {
        self.task = localRealm.objects(Routine.self)
        tableView.reloadData()
        print("Fire")
        
    }
    
    
}
