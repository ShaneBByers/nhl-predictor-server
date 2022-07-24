//
//  WebSeason.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/4/22.
//

import Foundation

struct WebSeasonList: WebData
{
    var path: String? = "seasons"
    
    var seasons: [WebSeason]?
}

struct WebSeason: Decodable
{
    var seasonId: String?
    var regularSeasonStartDate: String?
    var regularSeasonEndDate: String?
    var seasonEndDate: String?
    var numberOfGames: Int?
}
