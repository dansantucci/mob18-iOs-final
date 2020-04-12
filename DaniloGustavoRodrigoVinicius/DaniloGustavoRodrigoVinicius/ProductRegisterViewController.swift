//
//  ProductRegisterViewController.swift
//  DaniloGustavoRodrigoVinicius
//
//  Created by Gustavo on 28/03/20.
//  Copyright © 2020 Danilo S Nascimento. All rights reserved.
//

import UIKit
import CoreData

class ProductRegisterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var tvState: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    @IBOutlet weak var btAddEdit: UIButton!
    
    var fetchedResultsController: NSFetchedResultsController<State>!
    
    var product: Product?
    var state: State?
    
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedMe))
        ivProduct.addGestureRecognizer(tap)
        ivProduct.isUserInteractionEnabled = true
        
        loadState()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.done))
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancel))
        
        toolbar.setItems([cancelButton, doneButton], animated: false)
        
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()

        tvState.inputAccessoryView = toolbar
        tvState.inputView = self.pickerView
        
        tvState.inputView = pickerView
        
        
        
        if let product = product {
            tfName.text = product.name
            ivProduct.image = product.image
            tfPrice.text = "\(product.price)"
            swCard.isSelected = product.credit_card
            tvState.text = product.state!.name
            state = product.state
            btAddEdit.setTitle("Alterar", for: .normal)
        }
        
        
    }
    
    @objc func done(){
              
    let row = self.pickerView.selectedRow(inComponent: 0)
    tvState!.text = getPosition(row: row)
    let index = IndexPath.init(row: row, section: 0)
    state = fetchedResultsController.object(at: index)
    tvState.resignFirstResponder()
}
    
    @objc func cancel(){
        tvState.resignFirstResponder()
    }
    
    func getPosition(row: Int) -> String {
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        print(row)
        let indexPath = IndexPath.init(row: row, section: 0)
        let value = fetchedResultsController.object(at: indexPath)
        return value.name ?? "Error"
    }
    
    private func loadState(){
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        try? fetchedResultsController.performFetch()
    }
    
    @objc func tappedMe()
    {
        let alert = UIAlertController(title: "Selecionar imagem", message: "De onde você desejar escolher a imagem?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (_) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (_) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (_) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func addEditProduct(_ sender: Any) {
        if product == nil {
            product = Product(context: context)
        }
        
        product?.name = tfName.text
        product?.price = Double(tfPrice.text!) ?? 0
        product?.state = state!
        product?.credit_card = swCard.isOn
        product?.preview = ivProduct.image
        
        try? context.save()
        navigationController?.popViewController(animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let indexPath = IndexPath.init(row: row, section: 0)
        let state = fetchedResultsController.object(at: indexPath)
        return state.name
    }
    
    //MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

}

extension ProductRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            let aspectRatio = image.size.width / image.size.height
            let maxSize: CGFloat = 500
            var smallSize: CGSize
            if aspectRatio > 1 {
                smallSize = CGSize(width: maxSize, height: maxSize/aspectRatio)
            } else {
                smallSize = CGSize(width: maxSize*aspectRatio, height: maxSize)
            }
            
            UIGraphicsBeginImageContext(smallSize)
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            ivProduct.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}
