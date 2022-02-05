//
//  customUITabBar.swift
//  Hourglass
//
//  Created by Kanghos on 2021/12/06.
//

import UIKit
import RealmSwift

class customUITabBar: UITabBarController {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    let localRealm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearence = UITabBarAppearance()
        appearence.backgroundColor = .bgColor
        self.tabBar.standardAppearance = appearence
        
        
        if #available(iOS 15, *){
            self.tabBar.scrollEdgeAppearance = appearence
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        if self.localRealm.objects(Routine.self).first == nil {
            
            self.selectedIndex = 1
        } else {
            
            self.selectedIndex = 0
            
        }
        
    }
   
    
}
