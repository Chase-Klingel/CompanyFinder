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
    
}
