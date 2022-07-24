//
//  DatabaseTeamStats.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/9/22.
//

import Foundation

struct DatabaseTeamStats: DatabaseTable
{
    typealias ColumnType = TeamStatsColumn
    
    static var tableName = "TEAM_STATS"
    
    var gameId: Int?
    var teamId: Int?
    var goals: Int?
    var shots: Int?
    var ppGoals: Int?
    var ppOpportunities: Int?
    var pim: Int?
    var blockedShots: Int?
    var takeaways: Int?
    var giveaways: Int?
    var hits: Int?
    
    init() {}
    
    init(from decoder: Decoder)
    {
        let container = try? decoder.container(keyedBy: TeamStatsColumn.self)
        gameId = decodeInt(from: container, for: .gameId)
        teamId = decodeInt(from: container, for: .teamId)
        goals = decodeInt(from: container, for: .goals)
        shots = decodeInt(from: container, for: .shots)
        ppGoals = decodeInt(from: container, for: .ppGoals)
        ppOpportunities = decodeInt(from: container, for: .ppOpportunities)
        pim = decodeInt(from: container, for: .pim)
        blockedShots = decodeInt(from: container, for: .blockedShots)
        takeaways = decodeInt(from: container, for: .takeaways)
        giveaways = decodeInt(from: container, for: .giveaways)
        hits = decodeInt(from: container, for: .hits)
    }
    
    init(from webTeamStats: WebTeamStats.HomeAwayTeams.HomeAwayTeam, usingGameId game: Int)
    {
        gameId = game
        teamId = webTeamStats.team?.id
        
        let teamStats = webTeamStats.teamStats?.teamSkaterStats
        goals = teamStats?.goals
        shots = teamStats?.shots
        if let powerPlayGoalsDouble = teamStats?.powerPlayGoals
        {
            ppGoals = Int(powerPlayGoalsDouble)
        }
        if let powerPlayOpportunitiesDouble = teamStats?.powerPlayOpportunities
        {
            ppOpportunities = Int(powerPlayOpportunitiesDouble)
        }
        pim = teamStats?.pim
        blockedShots = teamStats?.blocked
        takeaways = teamStats?.takeaways
        giveaways = teamStats?.giveaways
        hits = teamStats?.hits
    }
    
    static func editableColumns() -> [TeamStatsColumn] {
        return TeamStatsColumn.allCases
    }
    
    func values() -> [TeamStatsColumn : Encodable] {
        return [.gameId: gameId,
                .teamId: teamId,
                .goals: goals,
                .shots: shots,
                .ppGoals: ppGoals,
                .ppOpportunities: ppOpportunities,
                .pim: pim,
                .blockedShots: blockedShots,
                .takeaways: takeaways,
                .giveaways: giveaways,
                .hits: hits]
    }
    
    enum TeamStatsColumn: String, DatabaseColumn
    {
        case gameId = "GAME_ID"
        case teamId = "TEAM_ID"
        case goals = "GOALS"
        case shots = "SHOTS"
        case ppGoals = "PP_GOALS"
        case ppOpportunities = "PP_OPPORTUNITIES"
        case pim = "PIM"
        case blockedShots = "BLOCKED_SHOTS"
        case takeaways = "TAKEAWAYS"
        case giveaways = "GIVEAWAYS"
        case hits = "HITS"
    }
}
