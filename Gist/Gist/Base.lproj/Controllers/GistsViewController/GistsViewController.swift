//
//  GistsViewController.swift
//  Gist
//
//  Created by Vinicius on 13/01/18.
//  Copyright © 2017 Vinicius Minozzi. All rights reserved.
//

import UIKit

class GistsViewController: UITableViewController, LoadContent, GistFavoriteDelegate {
    
    lazy var viewModel: GistsDelegate = GistsViewModel(view: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        loadContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadContent() {
        showLoader()
        viewModel.loadContent()
    }
    
    // MARK: LoadContent
    func didLoadContent(error: String?) {
        dismissLoader()
        if let error = error {
            showDefaultAlert(message: error, completeBlock: nil)
            return
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didLoadImage(identifier: String) {
        DispatchQueue.main.async {
            for cell in self.tableView.visibleCells {
                if let gistCell = cell as? GistCell, gistCell.identifer == identifier {
                    gistCell.setImage(with: self.viewModel.imageFromCache(identifier: identifier)) 
                }
            }
        }
    }
    
    // MARK: - Table view data source / delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GistCell.createCell(tableView: tableView, indexPath: indexPath) as GistCell
        cell.delegate = self
        cell.fill(with: viewModel.gistDTO(at: indexPath.row))
        
        if indexPath.row == viewModel.numberOfRows() - 1 {
            loadContent()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let gistCell = cell as? GistCell {
            gistCell.fill(with: viewModel.gistDTO(at: indexPath.row))
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let gistCell = tableView.cellForRow(at: indexPath) as? GistCell {
            performSegue(withIdentifier: "goToDetail", sender: viewModel.getDetailDTO(identifier: gistCell.identifer ?? "", row: indexPath.row)) 
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewcontroller = segue.destination as? GistDetailViewController, let dto = sender as? DetailDTO {
            detailViewcontroller.setup(dto: dto)
        }
    }
    
    
    // MARK: - GistFavoriteDelegate
    func didFavorite(with id: String, shouldFavorite: Bool) {
        viewModel.didFavorite(with: id, shouldFavorite: shouldFavorite)
    }
}
