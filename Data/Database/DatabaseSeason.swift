//
//  DatabaseSeason.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/4/22.
//

import Foundation

struct DatabaseSeason: DatabaseTable
{
    typealias ColumnType = SeasonColumn
    
    static var tableName = "SEASONS"
    
    var id: Int?
    var regularSeasonStartDate: Date?
    var regularSeasonEndDate: Date?
    var seasonEndDate: Date?
    var numberOfGames: Int?
    
    init() { }
    
    init(from decoder: Decoder)
    {
        let container = try? decoder.container(keyedBy: SeasonColumn.self)
        id = decodeInt(from: container, for: .id)
        regularSeasonStartDate = decodeDate(from: container, for: .regularSeasonStartDate, ofType: .dbDate)
        regularSeasonEndDate = decodeDate(from: container, for: .regularSeasonEndDate, ofType: .dbDate)
        seasonEndDate = decodeDate(from: container, for: .seasonEndDate, ofType: .dbDate)
        numberOfGames = decodeInt(from: container, for: .numberOfGames)
    }
    
    init(from webSeason: WebSeason)
    {
        if let idString = webSeason.seasonId
        {
            id = Int(idString)
        }
        
        let dateFormatter = getDateFormatter(for: .webDate)
        
        if let dateString = webSeason.regularSeasonStartDate
        {
            regularSeasonStartDate = dateFormatter.date(from: dateString)
        }
        
        if let dateString = webSeason.regularSeasonEndDate
        {
            regularSeasonEndDate = dateFormatter.date(from: dateString)
        }
        
        if let dateString = webSeason.seasonEndDate
        {
            seasonEndDate = dateFormatter.date(from: dateString)
        }
        
        numberOfGames = webSeason.numberOfGames
    }
    
    static func editableColumns() -> [SeasonColumn] {
        return SeasonColumn.allCases
    }
    
    func values() -> [SeasonColumn : Encodable] {
        return [.id: id,
                .regularSeasonStartDate: regularSeasonStartDate,
                .regularSeasonEndDate: regularSeasonEndDate,
                .seasonEndDate: seasonEndDate,
                .numberOfGames: numberOfGames]
    }
    
    enum SeasonColumn: String, DatabaseColumn
    {
        case id = "ID"
        case regularSeasonStartDate = "REGULAR_SEASON_START_DATE"
        case regularSeasonEndDate = "REGULAR_SEASON_END_DATE"
        case seasonEndDate = "SEASON_END_DATE"
        case numberOfGames = "NUMBER_OF_GAMES"
    }
}
