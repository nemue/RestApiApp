//
//  ViewController.swift
//  RestApiApp
//
//  Created by Nele Müller on 08.05.18.
//  Copyright © 2018 Nele Müller. All rights reserved.
//

import UIKit
import Alamofire

class SpeciesViewController: UIViewController {
    
    // MARK: - Properties
    
    let cellIdentifier = Constants.SpeciesViewConstants.speciesCellIdentifier
    var species: [Species]?
    var speciesWrapper: SpeciesWrapper?
    var isLoadingSpecies = false

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        self.loadSpeciesFromFirstWrapper()
    }
    
    // MARK: - Private Methods
    
    private func loadSpeciesFromFirstWrapper() {
        isLoadingSpecies = true
        
        let completionHandler = {(result: Result<SpeciesWrapper>) in
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
        
        NetworkManager.getFirstSpeciesWrapper (completionHandler: completionHandler)
    }
    
    private func loadSpeciesFromNextWrapper() {
        self.isLoadingSpecies = true
        if let species = self.species,
            let wrapper = self.speciesWrapper,
            let totalSpeciesCount = wrapper.count,
            species.count < totalSpeciesCount {
            
            let completionHandler = {(result: Result<SpeciesWrapper>) in
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
            
            NetworkManager.getNextSpeciesWrapper(wrapper, completionHandler: completionHandler)
        }
    }
    
    private func addSpeciesFromWrapper(_ wrapper: SpeciesWrapper){  
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

extension SpeciesViewController: UITableViewDataSource {
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
                    self.loadSpeciesFromNextWrapper()
                }
            }
        }
        colorCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func colorCell(cell: UITableViewCell, indexPath: IndexPath){
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = Constants.ColorConstants.veryLightGrey
        } else {
            cell.backgroundColor = Constants.ColorConstants.white
        }
    }
}

// MARK: – UITableView Delegate

extension SpeciesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO
    }
}


