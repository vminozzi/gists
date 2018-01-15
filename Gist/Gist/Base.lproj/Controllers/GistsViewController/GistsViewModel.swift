//
//  GistsViewModel.swift
//  Gist
//
//  Created by Vinicius on 13/01/18.
//  Copyright © 2017 Vinicius Minozzi. All rights reserved.
//

import UIKit
import AudioToolbox

protocol LoadContent: class {
    func didLoadContent(error: String?)
    func didLoadImage(identifier: String)
}

protocol GistsDelegate: class {
    func loadContent()
    func numberOfSections() -> Int
    func numberOfRows() -> Int
    func gistDTO(at row: Int) -> GistDTO
    func imageFromCache(identifier: String) -> UIImage?
    func getDetailDTO(identifier: String, row: Int) -> DetailDTO
    func didFavorite(with id: String, shouldFavorite: Bool)
}

protocol GistFavoriteDelegate: class {
    func didFavorite(with id: String, shouldFavorite: Bool)
}
    
struct GistDTO {
    var ownerName: String?
    var ownerPhoto: String?
    var ownerImage: UIImage?
    var type = ""
    var id = ""
    var favorite = false
}

class GistsViewModel: GistsDelegate {
    
    private var shouldLoadMore = true
    var gists = [Gist]()
    var favorites = [Gist]()
    private var page = 0
    private var cache = NSCache<NSString, UIImage>()
    
    private weak var loadContentDelegate: LoadContent?
    
    
    init(view: LoadContent?) {
        loadContentDelegate = view
        getFavorites()
    }
    
    // MAKR: - Gists
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return gists.count
    }
    
    func loadContent() {
        if shouldLoadMore {
            shouldLoadMore = false
            GistRequest(page: page).request { response, error in
                self.shouldLoadMore = true
                self.page = self.page + 1
                if let gists = response?.gists {
                    gists.forEach { self.gists.append($0) }
                }
                if response?.limitError?.message != nil {
                    self.shouldLoadMore = false
                }
                self.loadContentDelegate?.didLoadContent(error: response?.limitError?.message != nil ? response?.limitError?.message : error?.message)
            }
        }
    }
    
    func gistDTO(at row: Int) -> GistDTO {
        return GistDTO(ownerName: gists[row].owner?.login == nil ? "No name available" : gists[row].owner?.login,
                       ownerPhoto: gists[row].owner?.photo,
                       ownerImage: getImage(row: row),
                       type: gists[row].files?.fileList?.type ?? "",
                       id: gists[row].id,
                       favorite: isFavorite(id: gists[row].id))
    }
    
    func getImage(row: Int) -> UIImage? {
        if let imageCached = cache.object(forKey: NSString(string: gists[row].owner?.photo ?? "")) {
            return imageCached
        }
        let placeholder = UIImage(named: "placeholder-iimage")
        placeholder?.accessibilityIdentifier = "placeholder"
        cache.setObject(placeholder ?? UIImage(), forKey: NSString(string: gists[row].owner?.photo ?? ""))
        if let imageURL = gists[row].owner?.photo, let url = URL(string: imageURL) {
            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    self.cache.setObject(image, forKey: NSString(string: imageURL))
                    self.loadContentDelegate?.didLoadImage(identifier: imageURL)
                }
            }).resume()
        }
        return nil
    }
    
    func imageFromCache(identifier: String) -> UIImage? {
        return cache.object(forKey: NSString(string: identifier))
    }
    
    func getDetailDTO(identifier: String, row: Int) -> DetailDTO {
        return DetailDTO(name: gists[row].owner?.login ?? "",
                  type: gists[row].files?.fileList?.type ?? "",
                  image: cache.object(forKey: NSString(string: identifier)),
                  url: identifier)
    }
    
    func didFavorite(with id: String, shouldFavorite: Bool) {
        let pop = SystemSoundID(1520)
        AudioServicesPlaySystemSound(pop)
        
        let array = gists.filter { id == $0.id }
        guard let gist = array.first else {
            return
        }
        
        if shouldFavorite {
            LocalDataBase().save(object: gist)
            favorites.append(gist)
        } else {
            LocalDataBase().remove(object: gist)
            favorites = favorites.filter { id != $0.id }
        }
    }
    
    func getFavorites() {
        guard let array = LocalDataBase().load(object: Gist.self) else {
            return
        }
        favorites = array
    }
    
    func isFavorite(id: String) -> Bool {
        return favorites.filter { $0.id == id }.count > 0
    }
}
