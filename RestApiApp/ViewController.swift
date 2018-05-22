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
        Species.getSpecies { result in
            
            if let error = result.error {
                self.isLoadingSpecies = false
                let alert = UIAlertController(title: "Error", message: "Could not load first species: \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

            else if let speciesWrapper = result.value {
                self.addSpeciesFromWrapper(speciesWrapper)
                self.isLoadingSpecies = false
                self.tableView?.reloadData()
            }
        }
    }
    
    func loadMoreSpecies() {
        self.isLoadingSpecies = true
        if let species = self.species,
            let wrapper = self.speciesWrapper,
            let totalSpeciesCount = wrapper.count,
            species.count < totalSpeciesCount {
            Species.getNextSpeciesWrapper(wrapper){ result in
                
                if let error = result.error {
                    self.isLoadingSpecies = false
                    let alert = UIAlertController(title: "Error", message: "Could not load more species: \(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
                else if let moreWrapper = result.value {
                    self.addSpeciesFromWrapper(moreWrapper)
                    self.isLoadingSpecies = false
                    self.tableView?.reloadData()
                }
            }
        }
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
        if self.species == nil {
            return 0
        }
        return self.species!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let species = self.species, species.count >= indexPath.row {
            let speciesToShow = species[indexPath.row]
            cell.textLabel?.text = speciesToShow.name
            cell.detailTextLabel?.text = speciesToShow.classification
            
            let rowsToLoadFromBottom = 5
            let rowsLoaded = species.count
            
            if (!self.isLoadingSpecies && (indexPath.row >= (rowsLoaded - rowsToLoadFromBottom))){
                let totalRows = self.speciesWrapper?.count ?? 0
                let remainingSpeciesTolLoad = totalRows - rowsLoaded
                if (remainingSpeciesTolLoad > 0) {
                    self.loadMoreSpecies()
                }
            }
        }
        return cell
    }
}

// MARK: – UITableView Delegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO
    }
}


