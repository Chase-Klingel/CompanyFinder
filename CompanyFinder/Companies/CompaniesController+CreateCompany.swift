//
//  CompaniesController+CreateCompany.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/14/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

extension CompaniesController:
    CreateCompanyControllerDelegate {
    
    // MARK: - Add/Edit Company
    
    func didEditCompany(company: Company) {
        guard let row = companies.index(of: company)
            else { return }
        
        let indexPath = IndexPath(row: row, section: 0)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath =
            IndexPath(row: companies.count - 1, section: 0)
        
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}
