//
//  APIResponse.swift
//  Rick And Morty
//
//  Created by Florian  on 20/04/2021.
//

import Foundation

struct APIResponse: Decodable {
  
    var results : [Results]
}

struct Results: Decodable {
    var id : Int 
    var name : String
    var status : String
    var species : String
    var type : String
    var gender : String
    var image : String?
}
