//
//  ProductTableViewCell.swift
//  DaniloGustavoRodrigoVinicius
//
//  Created by Gustavo on 11/04/20.
//  Copyright © 2020 Danilo S Nascimento. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var ivPreview: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    func prepare(with product: Product){
        ivPreview.image = product.image
        lbName.text = product.name
        lbPrice.text = "U$ \(product.price)"
    }
}
