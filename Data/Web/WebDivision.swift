//
//  WebDivision.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/4/22.
//

import Foundation

struct WebDivisionList: WebData
{
    var path: String? = "divisions"
    
    var divisions: [WebDivision]?
}


struct WebDivision: Decodable
{
    var id: Int?
    var conference: Conference?
    var name: String?
    var abbreviation: String?
    
    struct Conference: Decodable
    {
        var id: Int?
    }
}
