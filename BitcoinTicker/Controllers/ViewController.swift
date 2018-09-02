//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolsArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var curentSymbolNum = 0
    var finalURL = ""

    //IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        finalURL = baseURL + currencyArray[0]
        getBitcoinPrice(url: finalURL)
    }

    
    //MARK: - UIPickerView Delegate methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        curentSymbolNum = row
        
        finalURL = baseURL + currencyArray[row]
        getBitcoinPrice(url: finalURL)
    }
    
    //MARK: - Networking
    
    func getBitcoinPrice(url: String) {
        SVProgressHUD.show()
        
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    //print("Sucess! Got the bitcion price data")
                    let bitcoinPriceJson : JSON = JSON(response.result.value!)

                    self.updateBitcoinPriceData(json: bitcoinPriceJson)

                } else {
                    //print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
                
                SVProgressHUD.dismiss()
            }
    }

    
    //MARK: - JSON Parsing
    
    func updateBitcoinPriceData(json : JSON) {
        
        if let btcPriceResult = json["last"].double {
            bitcoinPriceLabel.text = "\(Int(btcPriceResult)) \(currencySymbolsArray[curentSymbolNum])"
        } else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }

}

