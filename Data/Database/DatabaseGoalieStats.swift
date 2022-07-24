//
//  DatabaseGoalieStats.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/10/22.
//

import Foundation

struct DatabaseGoalieStats: DatabaseTable
{
    typealias ColumnType = GoalieStatsColumn
    
    static var tableName = "GOALIE_STATS"
    
    var gameId: Int?
    var teamId: Int?
    var playerId: Int?
    var shotsAgainst: Int?
    var saves: Int?
    var evenShotsAgainst: Int?
    var evenSaves: Int?
    var ppShotsAgainst: Int?
    var ppSaves: Int?
    var shShotsAgainst: Int?
    var shSaves: Int?
    var toiSec: Int?
    var decision: String?
    
    init() { }
    
    init(from decoder: Decoder)
    {
        let container = try? decoder.container(keyedBy: GoalieStatsColumn.self)
        gameId = decodeInt(from: container, for: .gameId)
        teamId = decodeInt(from: container, for: .teamId)
        playerId = decodeInt(from: container, for: .playerId)
        shotsAgainst = decodeInt(from: container, for: .shotsAgainst)
        saves = decodeInt(from: container, for: .saves)
        evenShotsAgainst = decodeInt(from: container, for: .evenShotsAgainst)
        evenSaves = decodeInt(from: container, for: .evenSaves)
        ppShotsAgainst = decodeInt(from: container, for: .ppShotsAgainst)
        ppSaves = decodeInt(from: container, for: .ppSaves)
        shShotsAgainst = decodeInt(from: container, for: .shShotsAgainst)
        shSaves = decodeInt(from: container, for: .shSaves)
        toiSec = decodeInt(from: container, for: .toiSec)
        decision = decodeString(from: container, for: .decision)
    }
    
    init(from webGoalieStats: WebPlayerStats.HomeAwayTeams.HomeAwayTeam.Player.PlayerStats.GoalieStats,
         usingGameId game: Int,
         usingTeamId team: Int,
         usingPlayerId player: Int)
    {
        gameId = game
        teamId = team
        playerId = player
        shotsAgainst = webGoalieStats.shots
        saves = webGoalieStats.saves
        evenShotsAgainst = webGoalieStats.evenShotsAgainst
        evenSaves = webGoalieStats.evenSaves
        ppShotsAgainst = webGoalieStats.powerPlayShotsAgainst
        ppSaves = webGoalieStats.powerPlaySaves
        shShotsAgainst = webGoalieStats.shortHandedShotsAgainst
        shSaves = webGoalieStats.shortHandedSaves
        toiSec = getTimeOnIceSeconds(from: webGoalieStats.timeOnIce)
        decision = webGoalieStats.decision
    }
    
    static func editableColumns() -> [GoalieStatsColumn] {
        return GoalieStatsColumn.allCases
    }
    
    func values() -> [GoalieStatsColumn : Encodable] {
        return [.gameId: gameId,
                .teamId: teamId,
                .playerId: playerId,
                .shotsAgainst: shotsAgainst,
                .saves: saves,
                .evenShotsAgainst: evenShotsAgainst,
                .evenSaves: evenSaves,
                .ppShotsAgainst: ppShotsAgainst,
                .ppSaves: ppSaves,
                .shShotsAgainst: shShotsAgainst,
                .shSaves: shSaves,
                .toiSec: toiSec,
                .decision: decision
        ]
    }
    
    enum GoalieStatsColumn: String, DatabaseColumn
    {
        case gameId = "GAME_ID"
        case teamId = "TEAM_ID"
        case playerId = "PLAYER_ID"
        case shotsAgainst = "SHOTS_AGAINST"
        case saves = "SAVES"
        case evenShotsAgainst = "EVEN_SHOTS_AGAINST"
        case evenSaves = "EVEN_SAVES"
        case ppShotsAgainst = "PP_SHOTS_AGAINST"
        case ppSaves = "PP_SAVES"
        case shShotsAgainst = "SH_SHOTS_AGAINST"
        case shSaves = "SH_SAVES"
        case toiSec = "TOI_SEC"
        case decision = "DECISION"
    }
}
