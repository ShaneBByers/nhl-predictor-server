//
//  DatabaseGame.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/4/22.
//

import Foundation

struct DatabaseGame: DatabaseTable
{
    typealias ColumnType = GameColumn
    
    static var tableName = "GAMES"
    
    var id: Int?
    var seasonId: Int?
    var homeTeamId: Int?
    var awayTeamId: Int?
    var date: Date?
    
    init() { }
    
    init(from decoder: Decoder)
    {
        let container = try? decoder.container(keyedBy: GameColumn.self)
        id = decodeInt(from: container, for: .id)
        seasonId = decodeInt(from: container, for: .seasonId)
        homeTeamId = decodeInt(from: container, for: .homeTeamId)
        awayTeamId = decodeInt(from: container, for: .awayTeamId)
        date = decodeDateTime(from: container, for: .date, ofType: .dbDate)
    }
    
    init(from webGame: WebGame)
    {
        id = webGame.gamePk
        
        if let seasonIdString = webGame.season
        {
            seasonId = Int(seasonIdString)
        }
        
        if let homeTeamIdString = webGame.teams?.home?.team?.id
        {
            homeTeamId = Int(homeTeamIdString)
        }
        
        if let awayTeamIdString = webGame.teams?.away?.team?.id
        {
            awayTeamId = Int(awayTeamIdString)
        }
        
        if let dateTimeString = webGame.gameDate
        {
            let dateTimeFormatter = getDateFormatter(for: .webDateTime)
            date = dateTimeFormatter.date(from: dateTimeString)
        }
    }
    
    static func editableColumns() -> [GameColumn] {
        return GameColumn.allCases
    }
    
    func values() -> [GameColumn : Encodable] {
        return [.id: id,
                .seasonId: seasonId,
                .homeTeamId: homeTeamId,
                .awayTeamId: awayTeamId,
                .date: date]
    }
    
    enum GameColumn: String, DatabaseColumn
    {
        case id = "ID"
        case seasonId = "SEASON_ID"
        case homeTeamId = "HOME_TEAM_ID"
        case awayTeamId = "AWAY_TEAM_ID"
        case date = "DATE"
    }
}
