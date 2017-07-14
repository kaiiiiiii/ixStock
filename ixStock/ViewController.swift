//
//  ViewController.swift
//  ixStock
//
//  Created by Kaiming Cheng on 7/10/17.
//  Copyright © 2017 Kaiming Cheng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftCharts
//import Firebase


class ViewController: UIViewController, StockServiceDelegate {
    @IBOutlet weak var TotalText: UITextField!
    @IBOutlet weak var shareText: UITextField!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var LatestPrice: UITextField!
    @IBOutlet weak var shareValue: UITextField!
    
    var result = Double()
    var share:Double = 0.0
    
    //call the class
    let receiveStockPrice = StockService()
    
    var chart: LineChart?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //This is the delegate of StockService()
        receiveStockPrice.delegate = self
        receiveStockPrice.getLatestStockPriceForShare(share: "MOMO" )

        //After StockService() get the data, it pass the price here, and we could call some other function to use this data, for say calculate the price
        //receiveStockPrice.getLatestStockPriceForShare(share: "APPL")
    
    }

    @IBAction func Calculate(_ sender: Any) {
        print (result)
        print ("test")
    }
    
    
   func didReceiveLatestClosingPrice(latestClosingPrice: Double) {
    
    
        var ShareAmount = shareValue.text!
        print(ShareAmount)
        if ShareAmount.characters.count > 0{
            share = Double(ShareAmount)!
        }
        result = latestClosingPrice * share
        TotalText.text = "\(result)"
        LatestPrice.text = "\(latestClosingPrice)"
       // share = Int(share)
        //shareValue.text = "\(share)"
        
    }
    
    func didReceiveStocks(stocks: [Stock]) {
        
        self.chart?.view.removeFromSuperview()
        var data: [(Double, Double)] = []
        var i = 0
        for stock in stocks {
            i += 1
            let singleTuple: (Double, Double) = (Double(i), stock.close!)
            data.append(singleTuple)
            print(data)
        }
        let highPrice = stocks[0].close! * 2
        let lowPrice = stocks[0].close! * 0.5
        
        
        let chartConfig = ChartConfigXY(
            xAxisConfig: ChartAxisConfig(from: 0, to: 120, by: 3),
            yAxisConfig: ChartAxisConfig(from: Double(lowPrice), to: highPrice, by: 2)
        )
       
        let frame = CGRect(x: 0, y: 0, width: self.chartView.frame.width-20, height: self.chartView.frame.height-20)

        chart = LineChart(
            frame: frame,
            chartConfig: chartConfig,
            xTitle: "Time(Days)",
            yTitle: "Price(Dollars)",
            lines: [
                (chartPoints: data, color: UIColor.blue)
            ])
        self.chart?.zoom(scaleX: 5000, scaleY: 5000)
        self.chartView.addSubview((chart?.view)!)

        
    }

    @IBAction func userInput(_ sender: Any) {
            self.chart?.view.removeFromSuperview()
            let frame = CGRect(x: 0, y: 0, width: self.chartView.frame.width, height: self.chartView.frame.height)
            chart = LineChart(
                frame: frame,
                chartConfig: ChartConfigXY(xAxisConfig: ChartAxisConfig(from: 0, to: 100, by: 10),
                                           yAxisConfig: ChartAxisConfig(from: 0, to: 100, by: 10)),
                xTitle: "X axis",
                yTitle: "Y axis",
                lines: [
                ])
            self.chartView.addSubview((chart?.view)!)
            self.chart?.update()
            receiveStockPrice.getLatestStockPriceForShare(share: (shareText.text!) )
    }
    
   
    
    
    func failedToReceiveStocks() {
        // Error!
    }
    
    
    
 
}

