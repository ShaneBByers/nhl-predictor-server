//
//  DatabasePlayerStats.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/9/22.
//

import Foundation

struct DatabaseSkaterStats: DatabaseTable
{
    typealias ColumnType = SkaterStatsColumn
    
    static var tableName = "SKATER_STATS"
    
    var gameId: Int?
    var teamId: Int?
    var playerId: Int?
    var goals: Int?
    var assists: Int?
    var shots: Int?
    var ppGoals: Int?
    var ppAssists: Int?
    var shGoals: Int?
    var shAssists: Int?
    var pim: Int?
    var faceoffTaken: Int?
    var faceoffWins: Int?
    var takeaways: Int?
    var giveaways: Int?
    var blockedShots: Int?
    var hits: Int?
    var toiSec: Int?
    var evenToiSec: Int?
    var ppToiSec: Int?
    var shToiSec: Int?
    
    init() { }
    
    init(from decoder: Decoder)
    {
        let container = try? decoder.container(keyedBy: SkaterStatsColumn.self)
        gameId = decodeInt(from: container, for: .gameId)
        teamId = decodeInt(from: container, for: .teamId)
        playerId = decodeInt(from: container, for: .playerId)
        goals = decodeInt(from: container, for: .goals)
        assists = decodeInt(from: container, for: .assists)
        shots = decodeInt(from: container, for: .shots)
        ppGoals = decodeInt(from: container, for: .ppGoals)
        ppAssists = decodeInt(from: container, for: .ppAssists)
        shGoals = decodeInt(from: container, for: .shGoals)
        shAssists = decodeInt(from: container, for: .shAssists)
        pim = decodeInt(from: container, for: .pim)
        faceoffTaken = decodeInt(from: container, for: .faceoffTaken)
        faceoffWins = decodeInt(from: container, for: .faceoffWins)
        takeaways = decodeInt(from: container, for: .takeaways)
        giveaways = decodeInt(from: container, for: .giveaways)
        blockedShots = decodeInt(from: container, for: .blockedShots)
        hits = decodeInt(from: container, for: .hits)
        toiSec = decodeInt(from: container, for: .toiSec)
        evenToiSec = decodeInt(from: container, for: .evenToiSec)
        ppToiSec = decodeInt(from: container, for: .ppToiSec)
        shToiSec = decodeInt(from: container, for: .shToiSec)
    }
    
    init(from stats: WebPlayerStats.HomeAwayTeams.HomeAwayTeam.Player.PlayerStats.SkaterStats,
         usingGameId game: Int,
         usingTeamId team: Int,
         usingPlayerId player: Int)
    {
        gameId = game
        teamId = team
        playerId = player
        goals = stats.goals
        assists = stats.assists
        shots = stats.shots
        ppGoals = stats.powerPlayGoals
        ppAssists = stats.powerPlayAssists
        shGoals = stats.shortHandedGoals
        shAssists = stats.shortHandedAssists
        pim = stats.penaltyMinutes
        faceoffTaken = stats.faceoffTaken
        faceoffWins = stats.faceOffWins
        takeaways = stats.takeaways
        giveaways = stats.giveaways
        blockedShots = stats.blocked
        hits = stats.hits
        toiSec = getTimeOnIceSeconds(from: stats.timeOnIce)
        evenToiSec = getTimeOnIceSeconds(from: stats.evenTimeOnIce)
        ppToiSec = getTimeOnIceSeconds(from: stats.powerPlayTimeOnIce)
        shToiSec = getTimeOnIceSeconds(from: stats.shortHandedTimeOnIce)
    }
    
    static func editableColumns() -> [SkaterStatsColumn] {
        return SkaterStatsColumn.allCases
    }
    
    func values() -> [SkaterStatsColumn : Encodable] {
        return [.gameId: gameId,
                .teamId: teamId,
                .playerId: playerId,
                .goals: goals,
                .assists: assists,
                .shots: shots,
                .ppGoals: ppGoals,
                .ppAssists: ppAssists,
                .shGoals: shGoals,
                .shAssists: shAssists,
                .pim: pim,
                .faceoffTaken: faceoffTaken,
                .faceoffWins: faceoffWins,
                .takeaways: takeaways,
                .giveaways: giveaways,
                .blockedShots: blockedShots,
                .hits: hits,
                .toiSec: toiSec,
                .evenToiSec: evenToiSec,
                .ppToiSec: ppToiSec,
                .shToiSec: shToiSec]
    }
    
    enum SkaterStatsColumn: String, DatabaseColumn
    {
        case gameId = "GAME_ID"
        case teamId = "TEAM_ID"
        case playerId = "PLAYER_ID"
        case goals = "GOALS"
        case assists = "ASSISTS"
        case shots = "SHOTS"
        case ppGoals = "PP_GOALS"
        case ppAssists = "PP_ASSISTS"
        case shGoals = "SH_GOALS"
        case shAssists = "SH_ASSISTS"
        case pim = "PIM"
        case faceoffTaken = "FACEOFF_TAKEN"
        case faceoffWins = "FACEOFF_WINS"
        case takeaways = "TAKEAWAYS"
        case giveaways = "GIVEAWAYS"
        case blockedShots = "BLOCKED_SHOTS"
        case hits = "HITS"
        case toiSec = "TOI_SEC"
        case evenToiSec = "EVEN_TOI_SEC"
        case ppToiSec = "PP_TOI_SEC"
        case shToiSec = "SH_TOI_SEC"
    }
}
