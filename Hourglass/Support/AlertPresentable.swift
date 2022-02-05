//
//  AlertPresentable.swift
//  Hourglass
//
//  Created by Kanghos on 2021/12/03.
//

import UIKit

protocol AlertPresentable {
    var presenter: UIViewController { get }
    func showDefaultAlert(title:String, message:String, actionTitle:String)
}

extension AlertPresentable {
    func showDefaultAlert(title: String, message:String, actionTitle:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(action)
        alert.view.tintColor = .black
        presenter.present(alert, animated: true, completion: nil)
    }
}
