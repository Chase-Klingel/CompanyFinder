//
//  Service.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/30/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import Foundation
import CoreData

struct Service {
    
    static let shared = Service()
    
    let urlString =
        "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer() {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print("Failed to download companies:", err)
                
                return
            }
            
            guard let data = data else { return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let jsonCompanies =
                    try jsonDecoder.decode([JSONCompany].self,
                                           from: data)
                
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
                
                jsonCompanies.forEach({ (jsonCompany) in
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    company.numEmployees = "1"
                    company.companyImage = Data()
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let foundedDate = dateFormatter.date(from: jsonCompany.founded)
                    
                    company.founded = foundedDate
                    
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        let employee = Employee(context: privateContext)
                        employee.fullName = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        
                        let employeeInfo = EmployeeInfo(context: privateContext)
                        let birthdayDate = dateFormatter.date(from: jsonEmployee.birthday)
                        employeeInfo.birthday = birthdayDate
                        employee.employeeInfo = employeeInfo
                        
                        employee.company = company
                    })
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch let err {
                        print("Failed to save company:", err)
                    }
                })
            } catch let err {
                print("Failed to decode:", err)
            }
            
        }.resume()
    }
}

struct JSONCompany: Decodable {
    let name: String
    let founded: String
    var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let type: String
    let birthday: String
}


