//
//  AmoutViewController.swift
//  DaniloGustavoRodrigoVinicius
//
//  Created by Gustavo on 11/04/20.
//  Copyright © 2020 Danilo S Nascimento. All rights reserved.
//

import UIKit
import CoreData

class AmoutViewController: UIViewController {

    @IBOutlet weak var lbInternational: UILabel!
    @IBOutlet weak var lbNational: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        checkValues()
        getProducts()
        // Do any additional setup after loading the view.
    }
    
    private var dolar: Double?
    private var iof: Double?
    
    func getProducts(){
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            let products = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Product]
            
            sumInternational(products: products)
            sumNational(products: products)
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    func sumInternational(products: [Product]){
        let total = products.map{ $0.price }.reduce(0, +)
        
        lbInternational.text = String("U$ \(total)")
    }
    
    func sumNational(products: [Product]){
        
        let internationalTotal = products.map{(product) in
            product.price * Double(product.state?.tax ?? 1)
        }.reduce(0, +)
        
        let national = internationalTotal * dolar!
        let withTax = national * (1.0 + (iof!/100.0))
        
        lbNational.text = "R$ \(withTax)"
        
        
    }

    func checkValues(){
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                if let result = dict["Dolar"]{
                    print(result)
                    dolar = Double("\(result)")
                }
                if let result = dict["IOF"]{
                    print(result)
                    iof = Double("\(result)")
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
