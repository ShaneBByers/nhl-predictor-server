//
//  WebConference.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/4/22.
//

import Foundation

struct WebConferenceList: WebData
{
    var path: String? = "conferences"
    
    var conferences: [WebConference]?
}

struct WebConference: Decodable
{
    var id: Int?
    var name: String?
    var abbreviation: String?
    var shortName: String?
}
