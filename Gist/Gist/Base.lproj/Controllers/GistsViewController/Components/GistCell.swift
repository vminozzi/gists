//
//  GistCell.swift
//  Gist
//
//  Created by Vinicius on 13/01/18.
//  Copyright © 2017 Vinicius Minozzi. All rights reserved.
//

import UIKit

class GistCell: UITableViewCell {
    
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerPhoto: UIImageView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate: GistFavoriteDelegate?
    var identifer: String?
    private var id = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCircleImage()
    }
    
    private func setCircleImage() {
        ownerPhoto.layer.cornerRadius = 10.0
    }
    
    func fill(with dto: GistDTO) {
        ownerPhoto.image = dto.ownerImage
        ownerName.text = dto.ownerName
        type.text = dto.type
        identifer = dto.ownerPhoto
        id = dto.id
        setImage(favorite: dto.favorite)
    }
    
    func setImage(with image: UIImage?) {
        ownerPhoto.image = image
    }
    
    private func setImage(favorite: Bool) {
        favoriteButton.isSelected = favorite
    }
    
    @IBAction func favorite(_ sender: UIButton) {
        delegate?.didFavorite(with: id, shouldFavorite: !sender.isSelected)
        sender.isSelected = !sender.isSelected
    }
}
