//
//  ViewController.swift
//  Hourglass
//
//  Created by Kanghos on 2021/11/18.
//

import UIKit
import Lottie

import SwiftUI

class MainViewController: UIViewController {
    
    //Lottie Animaiton
    let animationView : AnimationView = {
        let animView = AnimationView(name: "46436-sand-clock-timer")
        animView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animView.contentMode = .scaleAspectFill
        return animView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Launch Screen
        view.addSubview(animationView)
        animationView.center = view.center
        animationView.animationSpeed = 0.7
        
        animationView.play { (finish) in
            self.animationView.removeFromSuperview()
            
            print("finished")
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "MainTabBarController") //as! ShakeViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    
    
}

