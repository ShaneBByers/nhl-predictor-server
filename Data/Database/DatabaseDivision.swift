//
//  DatabaseDivision.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/4/22.
//

import Foundation

struct DatabaseDivision: DatabaseTable
{
    typealias ColumnType = DivisionColumn
    
    static var tableName = "DIVISIONS"
    
    var id: Int?
    var conferenceId: Int?
    var name: String?
    var abbreviation: String?
    
    init() { }
    
    init(from decoder: Decoder)
    {
        let container = try? decoder.container(keyedBy: DivisionColumn.self)
        id = decodeInt(from: container, for: .id)
        conferenceId = decodeInt(from: container, for: .conferenceId)
        name = decodeString(from: container, for: .name)
        abbreviation = decodeString(from: container, for: .abbreviation)
    }
    
    init(from webDivision: WebDivision)
    {
        id = webDivision.id
        conferenceId = webDivision.conference?.id
        name = webDivision.name
        abbreviation = webDivision.abbreviation
    }
    
    static func editableColumns() -> [DivisionColumn] {
        return DivisionColumn.allCases
    }
    
    func values() -> [DivisionColumn : Encodable] {
        return [.id: id,
                .conferenceId: conferenceId,
                .name: name,
                .abbreviation: abbreviation]
    }
    
    enum DivisionColumn: String, DatabaseColumn
    {
        case id = "ID"
        case conferenceId = "CONFERENCE_ID"
        case name = "NAME"
        case abbreviation = "ABBREVIATION"
    }
}
