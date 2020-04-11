//
//  ProductListViewController.swift
//  DaniloGustavoRodrigoVinicius
//
//  Created by Gustavo on 11/04/20.
//  Copyright © 2020 Danilo S Nascimento. All rights reserved.
//

import UIKit
import CoreData

class ProductListViewController: UITableViewController {

    var fetchedResultsController: NSFetchedResultsController<Product>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProduct()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let vc = segue.destination as? ProductRegisterViewController else {
            return
        }
        
        if(tableView.indexPathForSelectedRow != nil){
            vc.product = fetchedResultsController.object(at: tableView.indexPathForSelectedRow!)
        } else {
            return
        }
    }
    
    private func loadProduct(){
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "price", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductTableViewCell
        
        let product = fetchedResultsController.object(at: indexPath)
        
        cell.prepare(with: product)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let product = fetchedResultsController.object(at: indexPath)
            context.delete(product)
            
            try? context.save()
        }
    }
}

extension ProductListViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        tableView.reloadData()
    }
    
}
