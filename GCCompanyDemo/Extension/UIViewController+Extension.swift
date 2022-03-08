//
//  UIViewController+Extension.swift
//  GCCompany
//
//  Created by 박승태 on 2022/03/06.
//

import UIKit

extension UIViewController {
    
    func showAlert(with content: String) {
        
        let alertController = UIAlertController(title: nil,
                                                message: content,
                                                preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "확인",
                                        style: .default,
                                        handler: nil)
        
        alertController.addAction(closeAction)
        
        self.present(alertController,
                     animated: false,
                     completion: nil)
    }
}
