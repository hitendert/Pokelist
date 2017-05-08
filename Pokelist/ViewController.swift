//
//  ViewController.swift
//  Pokelist
//
//  Created by Hitender Thejaswi on 5/1/17.
//  Copyright © 2017 Hitender Thejaswi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{

    @IBOutlet weak var myCollection: UICollectionView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    //create an array of type Pokemon class
    var pokemonArray = [Pokemon]()
    var filteredPokemonArray = [Pokemon]()
    
    var searchMode : Bool = false
    var musicPlayer : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollection.dataSource = self
        myCollection.delegate = self
        mySearchBar.delegate = self
        
        mySearchBar.returnKeyType = UIReturnKeyType.done
        
        
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
            
        } catch let err as NSError {
            print("Error while playing music")
        }
        
    }
    
    
    func parsePokemonCSV(){
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            
            let rows = csv.rows
            
            for row in rows {
                
                let name = row["identifier"]!
                let pokeId = Int(row["id"]!)!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                
                pokemonArray.append(poke)
            }
            
        
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        
        
    }
    
    //This is where we create our cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let poke : Pokemon!
            
            
            if searchMode {
                
                poke = filteredPokemonArray[indexPath.row]
                cell.configureCell(poke)
                
            } else {
                
                poke = pokemonArray[indexPath.row]
                cell.configureCell(poke)
            }
            return cell
           
        
        } else {
            return UICollectionViewCell()
        }
        
        
    }

    // This will be called when we tap on an item in the collection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke : Pokemon!
        
        if searchMode {
            poke = filteredPokemonArray[indexPath.row]
        } else {
            poke = pokemonArray[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
    }
    
    // This is to tell how many items will be there in the collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchMode{
            return filteredPokemonArray.count
        }else {
        
        return pokemonArray.count
        }
    }
    
    //This is the number of sections in the collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // This is to define the size of the collectionView.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if mySearchBar.text == nil || mySearchBar.text == "" {
            searchMode = false
            myCollection.reloadData()
            view.endEditing(true)
            
        } else {
            searchMode = true
            
            let lower = mySearchBar.text!.lowercased()
            
            filteredPokemonArray = pokemonArray.filter({$0.name.range(of: lower) != nil})
            myCollection.reloadData()
            
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PokemonDetailVC" {
            
            if let destination = segue.destination as? PokemonDetailVC {
                
                if let seguePokeObject = sender as? Pokemon {
                    
                    destination.detailVCPokemon = seguePokeObject
                }
            }
        }
    }
    


}

