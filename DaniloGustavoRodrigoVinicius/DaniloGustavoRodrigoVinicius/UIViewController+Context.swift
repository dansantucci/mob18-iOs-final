//
//  UIViewController+Context.swift
//  DaniloGustavoRodrigoVinicius
//
//  Created by Gustavo on 22/03/20.
//  Copyright © 2020 Danilo S Nascimento. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
