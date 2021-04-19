//
//  CoreMLViewController.swift
//  Training_Day
//
//  Created by Florian  on 19/04/2021.
//

import UIKit
import CoreML
import Vision

class CoreMLViewController: UIViewController {

    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var predictionLabel: UILabel!
    
    @IBOutlet weak var LaunchML: UIButton!
    
    
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LaunchML.isEnabled = false
        picker.delegate = self
        picker.allowsEditing = false
    }
    
// ici toute les actions qui sont faites avec le bouton camera. la prise de photo par la camera et par la librairie grace à la fonction setupCamera.
    @IBAction func CameraAction(_ sender: UIButton ) {
        setupCamera()
    }
    
    func setupCamera(){
        let controller = UIAlertController(title: "Choisir une image", message: "Prendre une photo ou en Galerie", preferredStyle: .alert)
        let photo = UIAlertAction(title: "Appareil Photo", style: .default){ (action) in
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
        }
        let galerie = UIAlertAction(title: "Galerie de Photo", style: .default) { ( action ) in
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            controller.addAction(photo)
        }
        controller.addAction(galerie)
        present(controller, animated: true, completion: nil)
    }
    
    // toutes les actions qui vont se faire grace à la loupe.
    @IBAction func CoreMLAction(_ sender: Any) {
        //1.conversion de l image ne CGImage
        if let imageToParse = iv.image?.cgImage {
            do {
                //2.Creer un modele CoreML
                let model = try SqueezeNet(configuration: MLModelConfiguration())
                let mlModel = model.model
                do {
                    // 3.Conversion mlModel en VisionModel
                    let visionModel = try VNCoreMLModel(for: mlModel)
                    // 4.creer une requete
                    let request = VNCoreMLRequest(model: visionModel)  { (response, error) in
                        //7.annalyse
                        if let e = error {
                            print("Erreur \(e.localizedDescription)")
                        }
                        if let r = response.results as? [VNClassificationObservation]{
                            if let f = r.first{
                                let id = f.identifier
                                let confidenceToPercent = f.confidence * 100
                                let confidenceString = String(format: "%.2f", confidenceToPercent)
                                DispatchQueue.main.async {
                                    self.predictionLabel.numberOfLines = 0
                                    self.predictionLabel.text = "C est objet est \(id), le pourcentage de certitude est de \(confidenceString)"
                                }
                                
                            }
                        }
                    }
                    //5.handler
                    let handler = VNImageRequestHandler(cgImage: imageToParse, options: [:])
                    //6.faire une request
                    try handler.perform([request])
                }
                 
                catch{
                    print(error.localizedDescription)
                }
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    

}

extension CoreMLViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
   
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            self.iv.image = image
            self.LaunchML.isEnabled = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
