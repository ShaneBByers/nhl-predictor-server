//
//  TeamWeb.swift
//  PredictorServer
//
//  Created by Shane Byers on 3/13/22.
//

import Foundation

struct WebTeamList: WebData
{
    var path: String?
    
    var teams: [WebTeam]?
    
    init()
    {
        path = "teams"
    }
    
    init(forTeam teamId: Int)
    {
        path = "teams/\(teamId)"
    }
}

struct WebTeam: Decodable
{
    var id: Int?
    var division: Division?
    var venue: TeamVenue?
    var name: String?
    var locationName: String?
    var teamName: String?
    var abbreviation: String?
    
    struct Division: Decodable
    {
        var id: Int?
    }
    
    struct TeamVenue: Decodable
    {
        var timeZone: TeamTimeZone?
        
        struct TeamTimeZone: Decodable
        {
            var tz: String?
        }
    }
}
