//
//  SecondViewController.swift
//  DaniloGustavoRodrigoVinicius
//
//  Created by Danilo S Nascimento on 17/03/20.
//  Copyright © 2020 Danilo S Nascimento. All rights reserved.
//

import UIKit
import CoreData

class AdjustmentsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkValues()

    }
    
    @IBOutlet weak var dolar: UITextField!
    @IBOutlet weak var iof: UITextField!
    
    func checkValues(){
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                if let result = dict["Dolar"]{
                    print(result)
                    dolar?.text = "\(result)"
                }
                if let result = dict["IOF"]{
                    print(result)
                    iof?.text = "\(result)"
                }
            }
        }
    }
    
    @IBAction func TestAlert(_ sender: UIButton) {
        // create the alert
        
        let alert = UIAlertController(title: "Estados e Taxas", message: "Adicione os valores abaixo", preferredStyle: UIAlertController.Style.alert)
        //add textFields
        alert.addTextField { (state: UITextField!) in
            state.placeholder = "Insira o estado:"
        }
        
        alert.addTextField { (tax: UITextField!) in
            tax.placeholder = "Insira o imposto:"
        }
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { [weak alert] (action) -> Void in
            let states = alert?.textFields![0];
            let tax = alert?.textFields![1];
            self.saveData(states: states!, tax: tax!)
        }
    ))
        
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveData(states: UITextField, tax: UITextField){
        let state = State(context: context)
        
        state.name = states.text!
        state.tax = Float(tax.text!)!
        
        try? context.save()
        navigationController?.popViewController(animated: true)
        
    }

}
