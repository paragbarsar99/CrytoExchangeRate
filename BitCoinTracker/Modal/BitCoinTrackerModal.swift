//
//  BitCoinTrackerModal.swift
//  BitCoinTracker
//
//  Created by parag on 06/01/25.
//

import Foundation

struct BitCoinExchangeModal{
    var currency:ExchangeRate?
    init(currency: ExchangeRate? = nil) {
        self.currency = currency
    }
    
}
struct BitCoinAssetsModal{
    var assest:[Assets]?
    init(assest: [Assets]? = nil) {
        self.assest = assest
    }
}
