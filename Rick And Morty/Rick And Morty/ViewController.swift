//
//  ViewController.swift
//  Rick And Morty
//
//  Created by Florian  on 20/04/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
  
    @IBOutlet weak var tableView: UITableView!
    
    
   var results : [Results] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100

        getAPI()
      
    }
    
 

    func getAPI(){
       
        if let url = URL(string: "https://rickandmortyapi.com/api/character"){
            URLSession.shared.dataTask(with: url)  { (d, _, e) in
                if let data = d {
                    do{
                        let result = try JSONDecoder().decode(APIResponse.self, from: data)
                        let datas = result.results
                        DispatchQueue.main.async {
                            self.results = datas
                            self.tableView.reloadData()
                        }
                    }
                    catch{
                        print("dans le catch \(error.localizedDescription)")
                    }
                   
                }
                
                if let error = e{
                    print("PAS dans le catch \(error.localizedDescription)")
                }
            }.resume()
        }
        else{
            print("Erreur")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let  cell = tableView.dequeueReusableCell(withIdentifier: "Ricky") as? RickAndMortyCell{
            cell.data = results[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}


