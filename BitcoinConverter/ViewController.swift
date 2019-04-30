//
//  ViewController.swift
//  BitcoinConverter
//
//  Created by 黃品綸 on 2019/4/30.
//  Copyright © 2019 Univa Paycast. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    
    @IBOutlet weak var bitcoinPrice: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let myTitle = NSAttributedString(string: currencyArray[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        
        getBitcoinData(url: finalURL)
    }
    
    
    func getBitcoinData(url: String) {
        Alamofire.request(url, method: .get)
            .responseJSON { (response) in
                if response.result.isSuccess {
                    print("Success! Got the weather data")
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    
                    self.updateBitcoinData(json: bitcoinJSON)
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPrice.text = "Connection Issue"
                }
        }
    }
    
    func updateBitcoinData(json : JSON) {
        if let bitcoinResult = json["ask"].double {
            bitcoinPrice.text = "$ " + String(bitcoinResult)
        } else {
            bitcoinPrice.text = "Price Unavailable"
        }
    }
    
    
}

