//
//  PokemonDetailVC.swift
//  Pokelist
//
//  Created by Hitender Thejaswi on 5/5/17.
//  Copyright © 2017 Hitender Thejaswi. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var detailVCPokemon : Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var defenceLabel: UILabel!
    @IBOutlet weak var pokedexIDLabel: UILabel!
    @IBOutlet weak var baseAttackLabel: UILabel!
    @IBOutlet weak var evoLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var nextEvoImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = detailVCPokemon.name
        
        detailVCPokemon.downloadPokemonDetail {
            
            
            // Whatever we wetie will only be called after the network call is complete!
            
            self.updateUI()
        }
        
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func updateUI() {
    
        self.heightLabel.text = detailVCPokemon.height
        self.weightLabel.text = detailVCPokemon.weight
        self.defenceLabel.text = detailVCPokemon.defense
        self.baseAttackLabel.text = detailVCPokemon.attack
        self.mainImage.image = UIImage(named: "\(detailVCPokemon.pokedexId)")
        self.currentEvoImage.image = UIImage(named: "\(detailVCPokemon.pokedexId)")
        self.typeLabel.text = detailVCPokemon.type
        self.pokedexIDLabel.text = "\(detailVCPokemon.pokedexId)"
        self.descriptionLabel.text = detailVCPokemon.description
        
        if detailVCPokemon.nextEvoId == "" {
            self.evoLabel.text = "No Evolutions"
            self.nextEvoImage.isHidden = true
        } else {
            self.nextEvoImage.isHidden = false
            self.nextEvoImage.image = UIImage(named: detailVCPokemon.nextEvoId)
            
            let str = "Next Evolution : \(detailVCPokemon.nextEvoName) - LVL \(detailVCPokemon.nextEvoId)"
            self.evoLabel.text = str
        }
        
        
    }
        
    
    
}
