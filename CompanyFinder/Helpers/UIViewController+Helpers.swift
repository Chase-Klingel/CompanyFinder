//
//  UIViewController+Helpers.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/14/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupPlusButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal),
                            style: .plain,
                            target: self,
                            action: selector)
    }
}
