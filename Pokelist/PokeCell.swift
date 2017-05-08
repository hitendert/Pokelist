//
//  PokeCell.swift
//  Pokelist
//
//  Created by Hitender Thejaswi on 5/2/17.
//  Copyright © 2017 Hitender Thejaswi. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    
    // For each PokeCell, we will want to create a Pokemon Object
    var herePokemon : Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 10.0
    }
    
    // Lets create a function which will be called everytime we are ready to update the Cells in the CollectioViewCell
    func configureCell(_ comingPokemon : Pokemon) {
        
        self.herePokemon = comingPokemon
        
        nameLabel.text = self.herePokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.herePokemon.pokedexId)")
        
    }
    
    
    
    
    
}
