//
//  datahandler.swift
//  Save Data of People
//
//  Created by Rishav on 26/04/17.
//  Copyright © 2017 Rishav. All rights reserved.
//

import Foundation
class datahandler {
    static let shared = datahandler()
    func handleErrors(_ data: Data?, _ response: URLResponse?, _ error: NSError?, completionHandler: @escaping (_ result: [String:AnyObject]?, _ success: Bool, _ error: String?) -> Void) {
        guard (error == nil) else {
            completionHandler(nil, false, udacityconstants.NetworkProblem)
            return
        }
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            completionHandler(nil, false, udacityconstants.IncorrectDetail)
            return
        }
        guard let _ = data else {
            completionHandler(nil, false, udacityconstants.NoData)
            return
        }
    }
    
}
