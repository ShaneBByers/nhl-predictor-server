//
//  DatabaseConference.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/4/22.
//

import Foundation

struct DatabaseConference: DatabaseTable
{
    typealias ColumnType = ConferenceColumn
    
    static var tableName = "CONFERENCES"
    
    var id: Int?
    var name: String?
    var abbreviation: String?
    var shortName: String?
    
    init() { }
    
    init(from decoder: Decoder)
    {
        let container = try? decoder.container(keyedBy: ConferenceColumn.self)
        id = decodeInt(from: container, for: .id)
        name = decodeString(from: container, for: .name)
        abbreviation = decodeString(from: container, for: .abbreviation)
        shortName = decodeString(from: container, for: .shortName)
    }
    
    init(from webConference: WebConference)
    {
        id = webConference.id
        name = webConference.name
        abbreviation = webConference.abbreviation
        shortName = webConference.shortName
    }
    
    static func editableColumns() -> [ConferenceColumn] {
        ConferenceColumn.allCases
    }
    
    func values() -> [ConferenceColumn : Encodable] {
        return [.id: id,
                .name: name,
                .abbreviation: abbreviation,
                .shortName: shortName]
    }
    
    enum ConferenceColumn: String, DatabaseColumn
    {
        case id = "ID"
        case name = "NAME"
        case abbreviation = "ABBREVIATION"
        case shortName = "SHORT_NAME"
    }
}
