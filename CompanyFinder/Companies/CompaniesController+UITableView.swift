//
//  CompaniesController+UITableView.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/14/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

extension CompaniesController {
    
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
    
    override func tableView(_ tableView: UITableView,
                            heightForFooterInSection section: Int)
        -> CGFloat {
            
        return companies.count > 0 ? 0 : 150
    }
    
    // MARK: - Table View Style
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath)
        -> CGFloat {
            
        return 60
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
        let context =
            CoreDataManager.shared.persistentContainer.viewContext
        
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
