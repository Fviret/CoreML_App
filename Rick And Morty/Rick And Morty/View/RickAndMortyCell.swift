//
//  RickAndMortyCell.swift
//  Rick And Morty
//
//  Created by Florian  on 20/04/2021.
//

import UIKit

class RickAndMortyCell: UITableViewCell {

    @IBOutlet weak var imagePerso: UIImageView!
    @IBOutlet weak var namePerso: UILabel!
    @IBOutlet weak var DescriptionPerso: UILabel!
    
    var data: Results! {
        didSet {
            namePerso.text = data.name
            DescriptionPerso.text = "genre : \(data.gender), espece : \(data.species), statut : \(data.status)"
            if let urlString = data.image {
                if let url = URL(string: urlString){
                    URLSession.shared.dataTask(with: url) { (d, _, _) in
                        if let data = d{
                            let img = UIImage(data: data)
                            DispatchQueue.main.async {
                                self.imagePerso.image = img
                            }
                        }
                    }.resume()
                }
                
            }
        }
    }
}
    

