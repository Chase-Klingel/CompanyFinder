//
//  CompanyCell.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/13/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    // MARK: - Instance Variables
    
    var currentCompany: Company? {
        didSet {
            guard let company = currentCompany else { return }
            
            if let companyImage = company.companyImage {
                companyImageView.image = UIImage(data: companyImage)
            } else {
                companyImageView.image = #imageLiteral(resourceName: "select_photo_empty").withRenderingMode(.alwaysOriginal)
            }
            
            if let name = company.name, let founded = company.founded {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd, YYYY"
                
                let foundedDate = dateFormatter.string(from: founded)
             
                let companyNameAndFoundedDate = "\(name) - Founded: \(foundedDate)"
             
                companyLabel.text = companyNameAndFoundedDate
             } else {                
                companyLabel.text = "\(company.name ?? "") \(company.numEmployees ?? "")"
             }
        }
    }
    
    // MARK: - UI Elements
    
    let companyImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty").withRenderingMode(.alwaysOriginal))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25

        return iv
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.tealColor
        
        anchorCompanyImageView()
        anchorCompanyLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Position UI Elements
    
    private func anchorCompanyImageView() {
        addSubview(companyImageView)
        companyImageView.anchor(top: nil, leading: leadingAnchor,
                                bottom: nil, trailing: nil,
                                paddingTop: 0, paddingLeft: 16,
                                paddingBottom: 0, paddingRight: 0,
                                width: 50, height: 50)
        companyImageView.centerYAnchor
            .constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func anchorCompanyLabel() {
        addSubview(companyLabel)
        companyLabel.anchor(top: topAnchor, leading: companyImageView.trailingAnchor,
                            bottom: bottomAnchor, trailing: trailingAnchor,
                            paddingTop: 0, paddingLeft: 16,
                            paddingBottom: 0, paddingRight: 0,
                            width: 0, height: 0)
    }

}
