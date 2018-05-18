//
//  ViewController.swift
//  RestApiApp
//
//  Created by Nele Müller on 08.05.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    let cellIdentifier = "CellIdentifier"
    var species: [Species]?
    var speciesWrapper: SpeciesWrapper?
    var isLoadingSpecies = false

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        self.loadFirstSpecies()
    }
    
    // MARK: - Private Methods
    
    func loadFirstSpecies() {
        isLoadingSpecies = true
        Species.getSpecies (completionHandler: { result in // ANDERS ALS IM TUT -> "trailing closure"
            
            if let error = result.error {
                self.isLoadingSpecies = false
                let alert = UIAlertController(title: "Error", message: "Could not load first species: \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            let speciesWrapper = result.value
        })
    }
    
    func addSpeciesFromWrapper(_ wrapper: SpeciesWrapper){
        self.speciesWrapper = wrapper
        
        if self.species == nil {
            self.species = self.speciesWrapper?.species
        }
        else {
            self.species = self.species! + self.speciesWrapper!.species!
        }
    }
}

// MARK: – UITableView DataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        return cell
    }
}

// MARK: – UITableView Delegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO
    }
}


