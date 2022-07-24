//
//  Logger.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/22/22.
//

import Foundation
import OSLog

extension Logger
{
    static let id = "com.predictor.server"
    enum Category: String
    {
        case database
        case webRequest
        case testing
    }
}
