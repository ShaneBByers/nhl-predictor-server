//
//  WebPlayerStats.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/9/22.
//

import Foundation

struct WebPlayerStats: WebData
{
    var path: String?
    
    var teams: HomeAwayTeams?
    
    init(forGame game: Int)
    {
        path = "game/\(game)/boxscore"
    }
    
    struct HomeAwayTeams: Decodable
    {
        var home: HomeAwayTeam?
        var away: HomeAwayTeam?
        
        struct HomeAwayTeam: Decodable
        {
            var team: Team?
            var players: [String:Player]?
            
            struct Team: Decodable
            {
                var id: Int?
            }
            
            struct Player: Decodable
            {
                var person: Person?
                var stats: PlayerStats?
                
                struct Person: Decodable
                {
                    var id: Int?
                    var fullName: String?
                    var firstName: String?
                    var lastName: String?
                    var birthDate: String?
                    var height: String?
                    var weight: Int?
                    var shootsCatches: String?
                    var primaryPosition: Position?
                    
                    struct Position: Decodable
                    {
                        var type: String?
                        var abbreviation: String?
                    }
                }
                
                struct PlayerStats: Decodable
                {
                    var skaterStats: SkaterStats?
                    var goalieStats: GoalieStats?
                    
                    struct SkaterStats: Decodable
                    {
                        var timeOnIce: String?
                        var assists: Int?
                        var goals: Int?
                        var shots: Int?
                        var hits: Int?
                        var powerPlayGoals: Int?
                        var powerPlayAssists: Int?
                        var shortHandedGoals: Int?
                        var shortHandedAssists: Int?
                        var penaltyMinutes: Int?
                        var faceoffTaken: Int?
                        var faceOffWins: Int?
                        var takeaways: Int?
                        var giveaways: Int?
                        var blocked: Int?
                        var evenTimeOnIce: String?
                        var powerPlayTimeOnIce: String?
                        var shortHandedTimeOnIce: String?
                    }
                    
                    struct GoalieStats: Decodable
                    {
                        var timeOnIce: String?
                        var shots: Int?
                        var saves: Int?
                        var powerPlaySaves: Int?
                        var shortHandedSaves: Int?
                        var evenSaves: Int?
                        var shortHandedShotsAgainst: Int?
                        var evenShotsAgainst: Int?
                        var powerPlayShotsAgainst: Int?
                        var decision: String?
                    }
                }
            }
        }
    }
}
