//
//  CryptoCell.swift
//  CryptoTrackerApp
//
//  Created by JyLooi on 14/08/2025.
//

import UIKit

final class CryptoCell: UITableViewCell {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var tap: (() -> Void)?
    
    @IBAction func FavBtnTap(_ sender: Any) {
        tap?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.logo.image = UIImage()
        self.name.text = ""
        self.symbol.text = ""
        self.currentPrice.text = ""
        self.percentage.text = ""
    }
}
