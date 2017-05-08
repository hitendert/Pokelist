//
//  Pokemon.swift
//  Pokelist
//
//  Created by Hitender Thejaswi on 5/1/17.
//  Copyright © 2017 Hitender Thejaswi. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name : String!
    private var _pokedexId : Int!
    private var _description : String!
    private var _type : String!
    private var _defense : String!
    private var _height : String!
    private var _weight : String!
    private var _attack : String!
    private var _nextEvoTxt : String!
    private var _pokemonURL : String!
    private var _nextEvoName : String!
    private var _nextEvoId : String!
    private var _nextEvoLevel : String!
    
  
    
    var name : String {
        return _name
    }
    
    var pokedexId : Int {
        return _pokedexId
    }
    
    var pokemonURL : String {
        get {
        return _pokemonURL
        }
        set {
            _pokemonURL = newValue
        }
    }
    
    var description : String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type : String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense : String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height : String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight : String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack : String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvoTxt : String {
        if _nextEvoTxt == nil {
            _nextEvoTxt = ""
        }
        return _nextEvoTxt
    }
    
    var nextEvoName : String {
        if _nextEvoName == nil {
            _nextEvoName = ""
        }
        return _nextEvoName
    }
    
    var nextEvoId : String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nextEvoLevel : String {
        if _nextEvoLevel == nil {
            _nextEvoLevel = ""
        }
        return _nextEvoLevel
    }
    
    
    
    init (name : String, pokedexId : Int) {
        
        self._name = name
        self._pokedexId = pokedexId
        
        self.pokemonURL = "\(BASE_URL)\(URL_POKEMON)\(self._pokedexId!)/"
        
    }
    
    func downloadPokemonDetail(completed : @escaping DownloadComplete) {
        
        print("Hitu here")
        print("Hitu url = \(self.pokemonURL)")
        
     Alamofire.request(self.pokemonURL).responseJSON { (response) in
        
        if let dict = response.result.value as? Dictionary<String, Any> {
            
            if let weight = dict["weight"] as? String {
                self._weight = weight
            }
         
            if let height = dict["height"] as? String {
                self._height = height
            }
            
            if let attack = dict["attack"] as? Int {
                self._attack = "\(attack)"
            }
            
            if let defense = dict["defense"] as? Int {
                self._defense = "\(defense)"
            }
            
            if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                
                if let name = types[0]["name"] {
                    self._type = name.capitalized
                }
                
                if types.count > 1 {
                    
                    for x in 1..<types.count {
                        
                        if let name = types[x]["name"] {
                            self._type! += "/\(name.capitalized)"
                        }
                        
                    }
                    
                }
                
            } else {
                self._type = ""
            }
            
            if let desc = dict["descriptions"] as? [Dictionary<String, String>] , desc.count > 0 {
                
                if let descriptions = desc[0]["resource_uri"] {
                    
                    let descURL = "\(BASE_URL)\(descriptions)"
                    
                    print("Hitu desc URL = \(descURL)")
                    
                    Alamofire.request(descURL).responseJSON { (response) in
                     
                        if let dict2 = response.result.value as? Dictionary<String, Any> {
                            
                            if let desc2 = dict2["description"] as? String {
                                
                                let desc3 = desc2.replacingOccurrences(of: "POKMON", with: "pokemon")
                                
                                self._description! = desc3
                            }
                        }
                     completed()
                    }
                    
                }
                
            } else {
                self._description = ""
            }
            
            
            if let evolutions = dict["evolutions"] as? [Dictionary<String, Any>] , evolutions.count > 0 {
                
                
                if let nextEvo = evolutions[0]["to"] as? String {
                    
                    if nextEvo.range(of: "mega") == nil {
                        
                        self._nextEvoName = nextEvo
                        
                        print("Hitu next evo = \(self._nextEvoName)")
                        
                        if let uri = evolutions[0]["resource_uri"] as? String {
                            
                            print("Hitu uri = \(uri)")
                            let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                            let nextEvoID = newStr.replacingOccurrences(of: "/", with: "")
                            
                            self._nextEvoId = nextEvoID
                            
                            print("Hitu nextEvoId = \(self._nextEvoId)")
                            
                            if let lvlExist = evolutions[0]["level"] {
                                
                                if let lvl = lvlExist as? Int {
                                    
                                    self._nextEvoLevel = "\(lvl)"
                                    
                                    print("Hitu nextEvoLevel = \(self._nextEvoLevel)")
                                }
                                
                                
                            } else {
                                self._nextEvoLevel = ""
                            }
                            
                        }
                        
                    }
                }
                
                
                
            }
            
            
            
        }
        completed()
        }
    
    
    
    
}

}



