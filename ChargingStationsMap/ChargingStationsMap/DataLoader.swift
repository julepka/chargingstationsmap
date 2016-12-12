//
//  DataLoader.swift
//  ChargingStationsMap
//
//  Created by Julia Potapenko on 12/9/16.
//  Copyright © 2016 Julia Potapenko. All rights reserved.
//

import Foundation

class DataLoader {
    
    func buildURL(latitude: Double, longitude: Double, distance: Double) -> URL {
        return URL(string: "http://api.openchargemap.io/v2/poi/?output=json&latitude=\(latitude)&longitude=\(longitude)&distance=\(distance)")!
    }
    
    func downloadDataForLocation(latitude: Double, longitude: Double, distance: Double, completion: @escaping ([ChargingStation]) -> ()) {
        let url = buildURL(latitude: latitude, longitude: longitude, distance: distance)
        print("URL \(url)")
        var result: [ChargingStation] = []
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            if let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] {
                for station in json {
                    var chargingStation: ChargingStation? = nil
                    if let addressInfo = station["AddressInfo"] as? [String: AnyObject] {
                        var lat = 0.0
                        var long = 0.0
                        if let latitude = addressInfo["Latitude"] as? Double {
                            lat = latitude
                        } else {
                            continue
                        }
                        if let longitude = addressInfo["Longitude"] as? Double {
                            long = longitude
                        } else {
                            continue
                        }
                        chargingStation = ChargingStation(latitude: lat, longitude: long)
                        if let addressTitle = addressInfo["Title"] as? String {
                            chargingStation?.title = addressTitle
                        }
                        var addressString = ""
                        if let addressLine1 = addressInfo["AddressLine1"] as? String {
                            addressString.append(addressLine1)
                            addressString.append(", ")
                        }
                        if let addressLine2 = addressInfo["AddressLine2"] as? String {
                            addressString.append(addressLine2)
                            addressString.append(", ")
                        }
                        if let town = addressInfo["Town"] as? String {
                            addressString.append(town)
                            addressString.append(", ")
                        }
                        if let state = addressInfo["StateOrProvince"] as? String {
                            addressString.append(state)
                            addressString.append(" ")
                        }
                        if let postcode = addressInfo["Postcode"] as? String {
                            addressString.append(postcode)
                        }
                        chargingStation?.address = addressString
                    }
                    if let operatorInfo = station["OperatorInfo"] as? [String: AnyObject] {
                        if let operatorTitle = operatorInfo["Title"] as? String {
                            chargingStation?.operatorName = operatorTitle
                        }
                    }
                    if let usageType = station["UsageType"] as? [String: AnyObject] {
                        if let usageTitle = usageType["Title"] as? String {
                            chargingStation?.usageType = usageTitle
                        }
                    }
                    if let cstation = chargingStation {
                        result.append(cstation)
                    }
                }
                
            }
            print("Stations in list: \(result.count)")
            completion(result)
        }
        task.resume()
    }
}
