//
//  BitCoinTrackerData.swift
//  BitCoinTracker
//
//  Created by parag on 06/01/25.
//

import Foundation;



struct ErrorResponse:Codable,Error{
let message:String
let code:Int
}


struct ExchangeRate:Codable{
    var time: String
    var asset_id_base: String
    var asset_id_quote: String
    var rate:Double
}

struct Assets:Codable{
    let asset_id: String
    let name: String
}




