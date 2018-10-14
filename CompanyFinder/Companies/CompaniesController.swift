//
//  ViewController.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/6/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController,
    CreateCompanyControllerDelegate {
   
    // MARK: - Instance Variables
    
    private let cellId = "cellId"
    private var companies = [Company]()
    private let context =
        CoreDataManager.shared.persistentContainer.viewContext

    // MARK: - Fetch Companies
    
    func fetchCompanies() {
        let fetchRequest =
            NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            
            self.companies = companies
            self.tableView.reloadData()
        } catch let fetchErr {
            print("Failed to fetch companies: \(fetchErr)")
        }
    }
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCompanies()
        
        view.backgroundColor = .white
        navigationItem.title = "Companies"
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView.register(CompanyCell.self,
                           forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
                
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal),
                            style: .plain, target: self,
                            action: #selector(presentAddCompanyController))
        
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
        let batchDeleteRequest =
            NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
            var indexPathsToRemove = [IndexPath]()
            
            for (index, _) in companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            
            companies.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: .left)
        } catch let err {
            print("Batch delete failed: \(err)")
        }
    }
    
    // MARK: - Add/Edit Company
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath =
            IndexPath(row: companies.count - 1, section: 0)
        
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditCompany(company: Company) {
        guard let row = companies.index(of: company)
            else { return }
        
        let indexPath = IndexPath(row: row, section: 0)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int)
        -> Int {
            
        return companies.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
        
        -> UITableViewCell {
            
        let cell =
        tableView.dequeueReusableCell(withIdentifier: cellId,
                                              for: indexPath) as! CompanyCell

        let company = companies[indexPath.row]
        cell.currentCompany = company
            
        return cell
    }
    
    // MARK: - Table View Header
    
    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int)
        -> CGFloat {
            
        return 60
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int)
        -> UIView? {
            
        let view = UIView()
        view.backgroundColor = .lightBlue
            
        return view
    }
    
    // MARK: - Table View Footer
    
    override func tableView(_ tableView: UITableView,
                            viewForFooterInSection section: Int)
        -> UIView? {
        
        let label = UILabel()
        label.text = "No companies available..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
            
        return label
    }
    
    // MARK: - Table View Style
    
    override func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath)
        -> CGFloat {
        
        return 60
    }
    
    override func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int)
        -> CGFloat {
        
        return companies.count > 0 ? 0 : 150
    }
    
    // MARK: - Table View Delete/Edit Action
    
    override func tableView(_ tableView: UITableView,
                            editActionsForRowAt indexPath: IndexPath)
        -> [UITableViewRowAction]? {
            
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete",
                                                handler: deleteHandler)
        deleteAction.backgroundColor = UIColor.lightRed
            
        let editAction = UITableViewRowAction(style: .normal, title: "Edit",
                                              handler: editHandler)
        editAction.backgroundColor = UIColor.darkBlue
            
        return [deleteAction, editAction]
    }
    
    private func deleteHandler(action: UITableViewRowAction,
                               indexPath: IndexPath) {
        let company = self.companies[indexPath.row]
        
        self.companies.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
                
        context.delete(company)
        
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to delete company: \(saveErr)")
        }
    }
    
    private func editHandler(action: UITableViewRowAction,
                             indexPath: IndexPath) {
        let editCompanyController = CreateCompanyController()
        editCompanyController.company = companies[indexPath.row]
        editCompanyController.delegate = self
        let navController = UINavigationController(rootViewController: editCompanyController)
        
        present(navController, animated: true, completion: nil)
    }
}

