//
//  CurrencyCell.swift
//  PayPayCurrency
//
//  Created by Fachri Febrian on 15/08/2022.
//

import UIKit

class CurrencyCell: UICollectionViewCell {
    
    @IBOutlet weak var currencyNameLbl: UILabel!
    @IBOutlet weak var currencyAmountLbl: UILabel!
    @IBOutlet weak var holderView: UIView!
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateView()
    }
    
    func updateView() {
        self.holderView.layer.cornerRadius = 10
        self.holderView.layer.borderWidth = 2
        self.holderView.layer.borderColor = UIColor.black.cgColor
    }
}
