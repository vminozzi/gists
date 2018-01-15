//
//  GistDetailViewController.swift
//  Gist
//
//  Created by Vinicius on 13/01/18.
//  Copyright © 2017 Vinicius Minozzi. All rights reserved.
//

import UIKit

struct DetailDTO {
    var name = ""
    var type = ""
    var image: UIImage?
    var url = ""
}

class GistDetailViewController: UITableViewController {

    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerPhoto: UIImageView!
    
    private var dto = DetailDTO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCircleImage()
        populate()
    }
    
    private func setCircleImage() {
        ownerPhoto.layer.cornerRadius = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func populate() {
        ownerPhoto.image = dto.image
        type.text = dto.type
        ownerName.text = dto.name
        if dto.image?.accessibilityIdentifier == "placeholder" {
            if let url = URL(string: dto.url) {
                URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.ownerPhoto.image = image
                        }
                    }
                }).resume()
            }
        }
    }
    
    func setup(dto: DetailDTO) {
        self.dto = dto
    }
}
