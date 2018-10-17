//
//  CoreDataManager.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/8/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CompanyFinderModels")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Failed to load persistent stores: \(err)")
            }
        }
        
        return container
    }()
    
    // MARK: - Fetch Companies
    
    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            
            return companies
        } catch let fetchErr {
            print("Failed to fetch companies: \(fetchErr)")
            return []
        }
    }
    
    // MARK: - Reset
    
    func deleteAllCompanies() {
        let context = persistentContainer.viewContext
        
        let batchDeleteRequest =
            NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        
        do {
            try context.execute(batchDeleteRequest)
        } catch let err {
            print("Batch delete failed: \(err)")
        }
    }
    
    // MARK: - Fetch Employees
    
    func fetchEmployees() -> [Employee] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
        
        do {
            let employees = try context.fetch(fetchRequest)
            return employees
        } catch let err {
            print("Failed to fetch employees: \(err)")
            return []
        }
    }
    
    // MARK: - Create Employee
    
    func createEmployee(employeeName: String) -> Error? {
        let context = persistentContainer.viewContext
        
        let employee =
            NSEntityDescription
                .insertNewObject(forEntityName: "Employee", into: context)
        
        employee.setValue(employeeName, forKey: "name")
        
        do {
            try context.save()
            
            return nil
        } catch let err {
            print("Failed to save employee: \(err)")
            
            return err
        }
    }

}
