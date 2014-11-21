//
//  PriceViewController.swift
//  BitWatch
//
//  Created by Ahmed Eid on 19/11/2014.
//  Copyright (c) 2014 Ahmed Eid. All rights reserved.
//

import UIKit
import BitWatchKit

class PriceViewController: UIViewController {
  
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var horizontalLayoutConstraint: NSLayoutConstraint!
  
  let tracker = Tracker()
  let xOffset: CGFloat = -22
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.tintColor = UIColor.blackColor()
    
    horizontalLayoutConstraint.constant = 0
    
    let originalPrice = tracker.cachedPrice()
    updateDate(tracker.cachedDate())
    updatePrice(originalPrice)
    tracker.requestPrice { (price, error) -> () in
      if error? == nil {
        self.updateDate(NSDate())
        self.updateImage(originalPrice, newPrice: price!)
        self.updatePrice(price!)
      }
    }
  }
  
  private func updateDate(date: NSDate) {
    self.dateLabel.text = "Last updated \(Tracker.dateFormatter.stringFromDate(date))"
  }
  
  private func updateImage(originalPrice: NSNumber, newPrice: NSNumber) {
    if originalPrice.isEqualToNumber(newPrice) {
      horizontalLayoutConstraint.constant = 0
    } else {
      if newPrice.doubleValue > originalPrice.doubleValue {
        imageView.image = UIImage(named: "Up")
      } else {
        imageView.image = UIImage(named: "Down")
      }
      horizontalLayoutConstraint.constant = xOffset
    }
  }
  
  private func updatePrice(price: NSNumber) {
    self.priceLabel.text = Tracker.priceFormatter.stringFromNumber(price)
  }
}
