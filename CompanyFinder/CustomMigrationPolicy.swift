//
//  CustomMigrationPolicy.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 11/4/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {
    @objc func transformNumEmployeesForNum(forNum: NSNumber) -> String {
        if forNum.intValue < 150 {
            return "small"
        } else {
            return "very large"
        }
    }
}
