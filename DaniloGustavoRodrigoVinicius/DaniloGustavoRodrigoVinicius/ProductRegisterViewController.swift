//
//  ProductRegisterViewController.swift
//  DaniloGustavoRodrigoVinicius
//
//  Created by Gustavo on 28/03/20.
//  Copyright © 2020 Danilo S Nascimento. All rights reserved.
//

import UIKit

class ProductRegisterViewController: UIViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var tvState: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    @IBOutlet weak var btAddEdit: UIButton!
    
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tappedMe))
        ivProduct.addGestureRecognizer(tap)
        ivProduct.isUserInteractionEnabled = true
        
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
        product?.credit_card = swCard.isOn
        product?.preview = ivProduct.image
        
        try? context.save()
        navigationController?.popViewController(animated: true)
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
