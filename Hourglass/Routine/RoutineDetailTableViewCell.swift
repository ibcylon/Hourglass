//
//  RoutineDetailTableViewCell.swift
//  Hourglass
//
//  Created by Kanghos on 2021/11/28.
//

import UIKit
import PanModal

protocol SetsButtonClickedDelegate {
    func setsButtonClicked(at index:IndexPath)
}

class RoutineDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var secTextField: UITextField!
    
    let maxLength = 2
    
    var modalPresenter : (() -> ()) = {}
    var setsConfigurePresenter : (() -> ()) = {}
    var delegate : SetsButtonClickedDelegate!
    var indexPath : IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        weightTextField.delegate = self
        repsTextField.delegate = self
        secTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: weightTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: repsTextField)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextField.textDidChangeNotification, object: secTextField)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configUI(){
        
    }
    
    func configureCell(){
        
    }
    @IBAction func setsButtonClicked(_ sender: UIButton) {
        print("Sets Button Closure")
        setsConfigurePresenter()
        //self.delegate.setsButtonClicked(at: indexPath)
    }
    
    
    
}

extension RoutineDetailTableViewCell : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Cell TextField Closure")
        modalPresenter()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        
        guard let text = textField.text else { return false }
        
        if text.count >= maxLength && range.length == 0 && range.location < maxLength {
            return false
        }
        
        return true
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                if text.count > maxLength {
                    textField.resignFirstResponder()
                }
                
                if text.count >= maxLength {
                    let index = text.index(text.startIndex, offsetBy: maxLength)
                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                }
                
                
            }
        }
    }
}
