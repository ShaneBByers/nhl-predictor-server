//
//  WebGame.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/4/22.
//

import Foundation

struct WebGameList: WebData
{
    var path: String?
    
    var dates: [WebGameDate]?
    
    init(forSeason seasonId: Int)
    {
        path = "schedule?season=\(seasonId)"
    }
    
    struct WebGameDate: Decodable
    {
        var date: String?
        var games: [WebGame]?
    }
}

struct WebGame: Decodable
{
    var gamePk: Int?
    var gameType: String?
    var season: String?
    var gameDate: String?
    var teams: WebGameTeams?
    
    struct WebGameTeams: Decodable
    {
        var away: WebGameTeam?
        var home: WebGameTeam?
        
        struct WebGameTeam: Decodable
        {
            var team: WebGameTeamTeam?
            
            struct WebGameTeamTeam: Decodable
            {
                var id: Int?
            }
        }
    }
}
