//
//  ViewController.swift
//  BitCoinTracker
//
//  Created by parag on 06/01/25.
//

import UIKit

protocol BitCoinTrackerDelegate{
    func didUpdateAsset(res:BitCoinAssetsModal)
    func didUpdateExchange(res:BitCoinExchangeModal)
    func didUpdateError(_ error:Error)
}

class ViewController: UIViewController {
    var assets:[Assets]? = nil
    var mainview:MainView!
    
    var bitCoinTrackerManager = BitCoinTrackerManager()
    
    override func loadView() {
        mainview = MainView();
        view = mainview;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bitCoinTrackerManager.delegate = self
        mainview.picker.dataSource = self
        mainview.picker.delegate = self
        bitCoinTrackerManager.getAssets()
        // Do any additional setup after loading the view.
    }


}

extension ViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Only one column
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let data = assets {
            return data.count  // Number of rows is based on the items array
        }
        return 0
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let data = assets{
            return data[row].name
        }
        return nil
        // Return title for each row
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
 
        if let data = assets {
            let selectedItem = data[row];
            print(selectedItem)
            bitCoinTrackerManager.getExchangeRate(to: selectedItem.asset_id)
        }
    }
    
}


extension ViewController:BitCoinTrackerDelegate{
 
    func didUpdateAsset(res: BitCoinAssetsModal) {
        guard let data = res.assest else{
            return;
        }
        //update ui in main thread
        DispatchQueue.main.async {
            self.assets = data
            self.mainview.picker.reloadAllComponents()
        }
        //update ui in background thread 
        DispatchQueue.global(qos: .userInitiated).async {
            self.bitCoinTrackerManager.getExchangeRate(to: data[0].asset_id)
        }
      
    }
    
    func didUpdateExchange(res: BitCoinExchangeModal) {
        DispatchQueue.main.async {
            self.mainview.currency.text = res.currency?.asset_id_quote;
            if let rate = res.currency?.rate{
                self.mainview.value.text = String(format:"%.2f",rate)
            }
        }
    }
    
    func didUpdateError(_ error: Error) {
        print(error, " didUpdateError")
    }
    
    
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

#Preview{
    ViewController()
}
