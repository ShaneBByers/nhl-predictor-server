//
//  WebData.swift
//  PredictorServer
//
//  Created by Shane Byers on 3/13/22.
//

import Foundation

protocol WebData: Decodable
{
    var path: String? { get }
}
