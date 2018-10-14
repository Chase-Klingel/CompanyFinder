//
//  UIImageView+Style.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/13/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

extension UIImageView {
    func makeCirculor() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
