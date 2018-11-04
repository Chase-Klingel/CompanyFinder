//
//  CompaniesAutoUpdateController.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/29/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import CoreData

class CompaniesAutoUpdateController: UITableViewController,
    NSFetchedResultsControllerDelegate {
    
    // MARK: - Instance Variables
    
    let cellId = "cellId"
    
    // MARK: - FRC
    
    lazy var fetchedResultsController: NSFetchedResultsController<Company> = {
        let context =
            CoreDataManager.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: "name",
                                             cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch let err {
            print("Failed to perform fetch:", err)
        }
        
        return frc
    }()
    
    // MARK: - FRC Helpers
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Add Companies
    
    @objc private func handleAdd() {
        let context =
            CoreDataManager.shared.persistentContainer.viewContext
        let companyNames = ["Google", "Facebook", "GitHub", "Microsoft", "Amazon"]
        
        for index in (0..<companyNames.count) {
            let company = Company(context: context)
            company.name = companyNames[index]
        }
      
        do {
            try context.save()
        } catch let err {
            print("Failed to save company:", err)
        }
    }
    
    // MARK: - Delete Companies
    
    @objc private func handleDelete() {
        let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
        
        let context =
            CoreDataManager.shared.persistentContainer.viewContext
        
        do {
            let companiesWithC = try context.fetch(fetchRequest)
            
            companiesWithC.forEach { (company) in
                context.delete(company)
            }
            
            do {
                try context.save()
            } catch let err {
                print("Failed to delete companies:", err)
            }
        } catch let err {
            print("Failed to fetch companies containing capital B:", err)
        }
        
    }
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.darkBlue
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Add", style: .plain,
                            target: self, action: #selector(handleAdd)),
            UIBarButtonItem(title: "Delete", style: .plain,
                            target: self, action: #selector(handleDelete))
        ]
            
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        
        let refreshControl = UIRefreshControl()
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = .white
    }
    
    // MARK: - Download JSON
    
    @objc private func handleRefresh() {
        Service.shared.downloadCompaniesFromServer()
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: cellId,
                                          for: indexPath) as! CompanyCell
        
        let company = fetchedResultsController.object(at: indexPath)
        cell.currentCompany = company
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employeesListController = EmployeesController()
        employeesListController.company = fetchedResultsController.object(at: indexPath)
        navigationController?.pushViewController(employeesListController, animated: true)
    }
    
    // MARK: - Table View Section Style
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.text = fetchedResultsController.sectionIndexTitles[section]
        label.backgroundColor = .lightBlue
        
        return label
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}
