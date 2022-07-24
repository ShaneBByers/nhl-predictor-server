//
//  WebTeamStats.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/9/22.
//

import Foundation

struct WebTeamStats: WebData
{
    var path: String?
    
    var teams: HomeAwayTeams?
    
    init(forGame gameId: Int)
    {
        path = "game/\(gameId)/boxscore"
    }
    
    struct HomeAwayTeams: Decodable
    {
        var away: HomeAwayTeam?
        var home: HomeAwayTeam?
        
        struct HomeAwayTeam: Decodable
        {
            var team: Team?
            var teamStats: TeamStats?
            
            struct Team: Decodable
            {
                var id: Int?
            }
            
            struct TeamStats: Decodable
            {
                var teamSkaterStats: TeamSkaterStats?
                
                struct TeamSkaterStats: Decodable
                {
                    var goals: Int?
                    var pim: Int?
                    var shots: Int?
                    var powerPlayGoals: Double?
                    var powerPlayOpportunities: Double?
                    var blocked: Int?
                    var takeaways: Int?
                    var giveaways: Int?
                    var hits: Int?
                }
            }
        }
    }
}
