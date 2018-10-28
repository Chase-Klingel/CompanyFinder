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
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain,
                            target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Do Updates", style: .plain,
                            target: self, action: #selector(doUpdates))
        ]
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
    
    // MARK: - Batch Create
    
    @objc private func handleBatchCreate() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            (0...5).forEach({ (value) in
                let company = Company(context: backgroundContext)
                company.name = String(value)
            })
            
            do {
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    self.companies =
                        CoreDataManager.shared.fetchCompanies()
                }
            } catch let err {
                print("Failed to save companies:", err)
            }
        }
    }
    
    @objc private func doUpdates() {
        DispatchQueue.global(qos: .background).async {
            let mainThreadContext =
                CoreDataManager.shared.persistentContainer.viewContext
            
            let privateChildContext =
                NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            
            privateChildContext.parent = mainThreadContext
            
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            
            do {
                let companies = try privateChildContext.fetch(request)
                
                companies.forEach({ (company) in
                    company.name = "D: \(company.name ?? "")"
                })
                
                try privateChildContext.save()
                
                // move back to main thread to save updates on main thread context
                DispatchQueue.main.async {
                    do {
                        if (mainThreadContext.hasChanges) {
                            try mainThreadContext.save()
                        }
                        
                        self.tableView.reloadData()
                    } catch let err {
                        print("Failed to update companies:", err)
                    }
                }
            } catch let err {
                print("Failed to fetch companies:", err)
            }
            
        }
    }
}

