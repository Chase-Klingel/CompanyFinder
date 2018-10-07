//
//  ViewController.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/6/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Companies"
        tableView.backgroundColor = .darkBlue
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        
        setupNavigationStyle()
    }
    
    private func setupNavigationStyle() {
        

        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.barTintColor = .lightRed
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // handles small title text
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal),
                            style: .plain, target: self, action: #selector(handleAddCompany))
        
    }
    
    @objc private func handleAddCompany() {
        print("adding company")
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.backgroundColor = .tealColor
        
        return cell
    }
}

