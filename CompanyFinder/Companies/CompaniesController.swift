//
//  ViewController.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/6/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController {
   
    // MARK: - Instance Variables
    
    private(set) var cellId = "cellId"
    var companies = [Company]()
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        
        view.backgroundColor = .white
        navigationItem.title = "Companies"
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView.register(CompanyCell.self,
                           forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
                
        setupPlusButtonInNavBar(selector: #selector(presentAddCompanyController))
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: "Reset", style: .plain,
                            target: self, action: #selector(handleReset))
    }
    
    // MARK: - Present Add Company Controller
    
    @objc private func presentAddCompanyController() {
        let createCompanyController = CreateCompanyController()
        let navController = CustomNavigationController(rootViewController: createCompanyController)
        createCompanyController.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Reset
    
    @objc private func handleReset() {
        CoreDataManager.shared.deleteAllCompanies()
        
        var indexPathsToRemove = [IndexPath]()
        
        for (index, _) in companies.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            indexPathsToRemove.append(indexPath)
        }
        
        companies.removeAll()
        tableView.deleteRows(at: indexPathsToRemove, with: .left)
    }
}
