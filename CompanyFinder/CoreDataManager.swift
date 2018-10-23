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
    
    // MARK: - Create Company
    
    func createCompany(companyName: String,
                     companyFounded: Date,
                     companyImageData: Data) -> (Company?, Error?) {
        let context = persistentContainer.viewContext

        let company =
            NSEntityDescription
                .insertNewObject(forEntityName: "Company",
                                 into: context) as! Company
        
        company.setValue(companyName, forKey: "name")
        company.setValue(companyFounded, forKey: "founded")
        company.setValue(companyImageData, forKey: "companyImage")
        
        do {
            try context.save()
            return (company, nil)
        } catch let err {
            print("Failed to save new company: \(err)")
            
            return (nil, err)
        }
    }
    
    // MARK: - Update Company
    
    func updateCompany() -> Error? {
        let context = persistentContainer.viewContext

        do {
            try context.save()
            
            return nil
        } catch let err {
            print(err)
            
            return err
        }
    }
    
    // MARK: - Batch Delete Companies
    
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
    
    func fetchEmployees(company: Company) -> [Employee] {
        guard let companyEmployees = company.employees?.allObjects
            as? [Employee] else { return [] }
        
        return companyEmployees
    }
    
    // MARK: - Create Employee
    
    func createEmployee(employeeName: String,
                        birthday: Date,
                        company: Company)
        -> (Employee?, Error?) {
            
        let context = persistentContainer.viewContext
        
        let employee =
            NSEntityDescription
                .insertNewObject(forEntityName: "Employee",
                                 into: context) as! Employee
        
        // set employee name
        employee.setValue(employeeName, forKey: "name")
            
        // set employee company
        employee.company = company
            
        let employeeInfo =
            NSEntityDescription
                .insertNewObject(forEntityName: "EmployeeInfo",
                                 into: context) as! EmployeeInfo
        employeeInfo.birthday = birthday
        
        // set employee info
        employee.employeeInfo = employeeInfo
        
        do {
            try context.save()
            
            return (employee, nil)
        } catch let err {
            print("Failed to save employee: \(err)")
            
            return (nil, err)
        }
    }

}
