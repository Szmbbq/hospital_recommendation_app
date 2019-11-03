//
//  hospitalViewCell.swift
//  HospitalRecommendation
//
//  Created by xxx on 2019/11/2.
//  Copyright © 2019 Szmbbq. All rights reserved.
//

import UIKit

class HospitalViewCell: UITableViewCell {
    // MARK: - Properties
    var hospitalName: UITextView?
    var hospitalDistance: UILabel?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        hospitalName = UITextView()
        addSubview(hospitalName!)
        hospitalName?.translatesAutoresizingMaskIntoConstraints = false
        hospitalName?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        hospitalName?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        hospitalName?.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        hospitalDistance = UILabel()
        addSubview(hospitalDistance!)
        hospitalDistance?.translatesAutoresizingMaskIntoConstraints = false
        hospitalDistance?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        hospitalDistance?.topAnchor.constraint(equalTo: hospitalName!.bottomAnchor, constant: 5).isActive = true
        hospitalDistance?.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        hospitalDistance?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    

}
