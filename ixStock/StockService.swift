//
//  StockService.swift
//  ixStock
//
//  Created by Kaiming Cheng on 7/11/17.
//  Copyright © 2017 Kaiming Cheng. All rights reserved.
//

import Foundation
import Alamofire
import SwiftCharts

protocol StockServiceDelegate {
    func didReceiveLatestClosingPrice(latestClosingPrice: Double)
    func didReceiveStocks(stocks: [Stock])
    func failedToReceiveStocks()
}

class StockService {
    var delegate: StockServiceDelegate?
    // function of StockService, which get the price, pass that data to function didReceiveLatestClosingPrice for the delegate, so that view controller could use this data from the delegate 
    func getLatestStockPriceForShare(share: String) {
        Alamofire.request("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=\(share)&apikey=PQ5QYQO56YA83I2A", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                // guard let function
                guard let stockResponse = value as? [String: AnyObject?] else {
                    print("No stock response")
                    break
                }
                
                guard let timeSeriesDict = stockResponse["Time Series (Daily)"] as? [String: AnyObject?] else {
                    print("No time series")
                    break
                }
                var stocks: [Stock] = []
                
                for (key, value) in timeSeriesDict {
                    guard let stockDict = value as? [String: AnyObject] else {
                        print("No stock dict")
                        return
                    }
                    let stock = Stock(dictionary: stockDict)
                    let dateFormatter = DateFormatter()
                    if key.characters.count > 10 {
                        dateFormatter.dateFormat = "yyyy'-'MM'-'dd hh':'mm':'ss"
                    } else {
                        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
                    }
                    stock!.date = dateFormatter.date(from: key)
                    stocks.append(stock!)
                }
                stocks.sort { $0.date! < $1.date! }
                if let closingPrice = stocks[40].close {
                    self.delegate?.didReceiveLatestClosingPrice(latestClosingPrice: closingPrice)
                }
                self.delegate?.didReceiveStocks(stocks: stocks)
                break
            case .failure(let error):
                print(error)
                self.delegate?.failedToReceiveStocks()
                break
            }
        }
    }
 
            
}


    

