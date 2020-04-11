//
//  Product+image.swift
//  DaniloGustavoRodrigoVinicius
//
//  Created by Gustavo on 28/03/20.
//  Copyright © 2020 Danilo S Nascimento. All rights reserved.
//

import UIKit

extension Product {
    var image: UIImage? {
        return self.preview as? UIImage
    }
}
