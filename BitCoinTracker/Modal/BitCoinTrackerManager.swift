//
//  BitCoinTrackerManager.swift
//  BitCoinTracker
//
//  Created by parag on 06/01/25.
//

import Foundation
import ToastViewSwift
typealias completion<T> = (Result<T,Error>) -> Void

struct BitCoinTrackerManager{
    private let baseUrl = "https://rest.coinapi.io/v1"
    
    //header will be for auth X-CoinAPI-Key:= 685fb699-42c5-4167-b45f-746cdb82b0c8
    
    // or use query params ?apikey=73034021-THIS-IS-SAMPLE-KEY
    var delegate:BitCoinTrackerDelegate?
    
    private func responseUnWrap(_ safeData:Data) -> String?{
        if let jsonString = String(data: safeData, encoding: .utf8) {
            return jsonString
        }
        return nil
    }
    
    func errorJSONParser(_ data:Data) -> Error?{
        do{
            let response = try JSONDecoder().decode(ErrorResponse.self,from: data)
            print("errorJSONParser", response)
            return response
        }catch{
            return nil
        }
    }
    
    func getExchangeRate(to asset:String){
        let reqUrl = "\(baseUrl)/exchangerate/BTC/\(asset)"
        performRequest(url:reqUrl,responseType:ExchangeRate.self,completion:{res in
            switch res {
            case .success(let exchangeRate):
                let exchange = BitCoinExchangeModal(currency: exchangeRate)
                delegate?.didUpdateExchange(res: exchange)
                break;
            case .failure(let error):
                print(error)
                Toast.text(error.localizedDescription).show();
                delegate?.didUpdateError(error);
                break;
            }
        })
    }
    func getAssets(){
        let reqUrl = "\(baseUrl)/assets"
        print(reqUrl)
        performRequest(url:reqUrl,responseType:[Assets].self,completion:{res in
            switch res {
            case .success(let assets):
//                print(assets[0].asset_id, " exchangeRate.rate")
                let assets = BitCoinAssetsModal(assest: assets)
                delegate?.didUpdateAsset(res: assets)
                break;
            case .failure(let error):
                print(error)
                // Toast.text(error.localizedDescription).show();
                delegate?.didUpdateError(error);
                break;
            }
        })
        
    }
    
    private  func responseHandler<T:Codable>(data:Data?,urlResponse:URLResponse?,error:Error?,responseType:T.Type,completion: @escaping completion<T>){
        if(error != nil){
            print(error!," responseHandler")
            completion(.failure(error!))
            return
        }
        
        //convert the data into string
        if let safeData = data {
            if let error = errorJSONParser(safeData){
                completion(.failure(error))
            }
            if let response = parseJSON(data:safeData,type:responseType){
                completion(.success(response))
            }
        }else {
            let noDataError = NSError(domain: "ResponseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
            completion(.failure(noDataError))
        }
        
    }
    private  func performRequest<T:Codable>(url:String,responseType:T.Type,completion:@escaping completion<T>){
        //1.Create url for request
        if let reqUrl = URL(string: url){
            // Create a URLRequest object
            var request = URLRequest(url: reqUrl);
            request.httpMethod = "GET"
            request.addValue("685fb699-42c5-4167-b45f-746cdb82b0c8", forHTTPHeaderField: "X-CoinAPI-Key")
            //2.create a URLSession
            let session = URLSession(configuration: .default);
            
            //3.Give the session a task
            let task = session.dataTask(with: request){data,urlResponse,error in
                responseHandler(data:data,urlResponse:urlResponse,error:error,responseType:responseType,completion:completion)
            }
            
            //4.start the task;
            task.resume();
        }
    }
    
    private func parseJSON<T:Codable>(data:Data,type:T.Type) -> T?{
        do{
            let response = try JSONDecoder().decode(type.self, from: data)
            return response
        }catch{
            print(error)
            return nil;
    
        }
    }
}
