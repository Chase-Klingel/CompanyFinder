//
//  UIViewController+Helpers.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/14/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Navigation Related Items
    
    func setupPlusButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal),
                            style: .plain,
                            target: self,
                            action: selector)
    }
    
    func setupCancelButton() {
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: "Cancel",
                            style: .plain,
                            target: self,
                            action: #selector(handleCancel))
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupSaveButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Save",
                            style: .plain,
                            target: self,
                            action: selector)
    }
    
    // MARK: - Background View For CreateEmployee/CreateCompany
    
    func anchorBackgroundView(height: CGFloat) -> UIView {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .lightBlue
        
        view.addSubview(backgroundView)
        backgroundView.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                              bottom: nil, trailing: view.trailingAnchor,
                              paddingTop: 0, paddingLeft: 0,
                              paddingBottom: 0, paddingRight: 0,
                              width: 0, height: height)
        
        return backgroundView
    }

    // MARK: - Alert For Error On Save
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                          message: message,
                          preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Okay",
                                          style: .default,
                                          handler: nil)
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
}
