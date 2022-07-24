//
//  Team.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/27/22.
//

import Foundation

struct DatabaseTeam : DatabaseTable
{
    typealias ColumnType = TeamColumn
    
    static var tableName = "TEAMS"
    
    var id: Int?
    var divisionId: Int?
    var fullName: String?
    var locationName: String?
    var nickname: String?
    var abbreviation: String?
    var timezone: String?
    
    init() { }
    
    init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: TeamColumn.self)
        id = decodeInt(from: container, for: .id)
        divisionId = decodeInt(from: container, for: .divisionId)
        fullName = decodeString(from: container, for: .fullName)
        locationName = decodeString(from: container, for: .locationName)
        nickname = decodeString(from: container, for: .nickname)
        abbreviation = decodeString(from: container, for: .abbreviation)
        timezone = decodeString(from: container, for: .timezone)
    }
    
    init(from webTeam: WebTeam)
    {
        id = webTeam.id
        divisionId = webTeam.division?.id
        fullName = webTeam.name
        locationName = webTeam.locationName
        nickname = webTeam.teamName
        abbreviation = webTeam.abbreviation
        timezone = webTeam.venue?.timeZone?.tz
    }
    
    static func editableColumns() -> [TeamColumn]
    {
        return TeamColumn.allCases
    }
    
    func values() -> [TeamColumn:Encodable]
    {
        return [.id: id,
                .divisionId: divisionId,
                .fullName: fullName,
                .locationName: locationName,
                .nickname: nickname,
                .abbreviation: abbreviation,
                .timezone: timezone]
    }
    
    enum TeamColumn: String, DatabaseColumn
    {
        case id = "ID"
        case divisionId = "DIVISION_ID"
        case fullName = "FULL_NAME"
        case locationName = "LOCATION_NAME"
        case nickname = "NICKNAME"
        case abbreviation = "ABBREVIATION"
        case timezone = "TIMEZONE"
    }
}
