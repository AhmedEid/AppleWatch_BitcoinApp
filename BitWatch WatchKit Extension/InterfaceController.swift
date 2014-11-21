//
//  InterfaceController.swift
//  BitWatch WatchKit Extension
//
//  Created by Ahmed Eid on 11/21/14.
//  Copyright (c) 2014 Ahmed Eid. All rights reserved.
//

import WatchKit
import Foundation
import BitWatchKit

class InterfaceController: WKInterfaceController {

    let tracker = Tracker()
    var updating = false
    
    @IBOutlet weak var priceLabel: WKInterfaceLabel!
    @IBOutlet weak var image: WKInterfaceImage!
    
    @IBOutlet weak var lastUpdatedLabel: WKInterfaceLabel!
    @IBAction func refreshTapped() {
        update()
    }
    
    override init(context: AnyObject?) {
        // Initialize variables here.
        super.init(context: context)
        
        // Configure interface objects here.
        updatePrice(tracker.cachedPrice())
        image.setHidden(true)
        updateDate(tracker.cachedDate())
        NSLog("%@ init", self)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        update()
        NSLog("%@ will activate", self)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
    }
    
    private func updatePrice(price:NSNumber) {
        priceLabel.setText(Tracker.priceFormatter.stringFromNumber(price))
    }
    
    private func updateDate(date:NSDate) {
        self.lastUpdatedLabel.setText("Last updated \(Tracker.dateFormatter.stringFromDate(date))")
    }
    
    private func updateImage(originalPrice:NSNumber, newPrice:NSNumber) {
        if originalPrice.isEqualToNumber(newPrice){
            //setHidden causes the layout to reload
            image.setHidden(true)
        } else {
            if (newPrice.doubleValue > originalPrice.doubleValue){
                image.setImageNamed("Up")
            } else {
                image.setImageNamed("Down")
            }
            image.setHidden(false)
        }
    }

    private func update () {
        if !updating {
            updating = true
            let originalPrice = tracker.cachedPrice()
            tracker.requestPrice({ (price, error) -> () in
                if error == nil {
                    self.updatePrice(price!)
                    self.updateDate(NSDate())
                    self.updateImage(originalPrice, newPrice: price!)
                    self.updating = false
                }
            })
        }
    }
    
}
