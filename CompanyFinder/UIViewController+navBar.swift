//
//  ViewFormatter.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/7/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

extension UIViewController {
    func buildNavBar() {
        navigationController?.navigationBar.isTranslucent = false

        navigationController?.navigationBar.barTintColor = .lightRed

        navigationController?.navigationBar.prefersLargeTitles = true

        // handles small title text
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]

        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}
