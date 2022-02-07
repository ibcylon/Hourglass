//
//  OnboardingViewController.swift
//  Hourglass
//
//  Created by Kanghos on 2022/02/06.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shakeIcon: UIImageView!
    @IBOutlet weak var routineIcon: UIImageView!
    @IBOutlet weak var shakeTextView: UITextView!
    @IBOutlet weak var routineTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        navigationButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    func configureUI(){
        self.view.backgroundColor = .white
        
        titleLabel.textAlignment = .center
        titleLabel.font = .sceneTitle
        let attributeText = NSMutableAttributedString(string: "Shake Timer")
        attributeText.addAttribute(.foregroundColor, value: UIColor.contentFortePink, range: NSRange(location: 0, length: 5))
        titleLabel.attributedText = attributeText
        shakeIcon.tintColor = .contentPink
        routineIcon.tintColor = .contentPink
        
        shakeTextView.font = .contentTitle
        routineTextView.font = .contentTitle
        
        navigationButton.layer.cornerRadius = 20
        navigationButton.backgroundColor = .contentFortePink
        navigationButton.tintColor = .white
    }
    
    @objc func buttonClicked() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
