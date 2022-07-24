//
//  DatabasePlayer.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/9/22.
//

import Foundation

struct DatabasePlayer: DatabaseTable
{
    typealias ColumnType = PlayerColumn
    
    static var tableName = "PLAYERS"
    
    var id: Int?
    var fullName: String?
    var firstName: String?
    var lastName: String?
    var birthdate: Date?
    var heightInches: Int?
    var weight: Int?
    var shootsCatches: String?
    var position: String?
    var positionType: String?
    
    init() { }
    
    init(from decoder: Decoder)
    {
        let container = try? decoder.container(keyedBy: PlayerColumn.self)
        id = decodeInt(from: container, for: .id)
        fullName = decodeString(from: container, for: .fullName)
        firstName = decodeString(from: container, for: .firstName)
        lastName = decodeString(from: container, for: .lastName)
        birthdate = decodeDateTime(from: container, for: .birthdate, ofType: .dbDate)
        heightInches = decodeInt(from: container, for: .heightInches)
        weight = decodeInt(from: container, for: .weight)
        shootsCatches = decodeString(from: container, for: .shootsCatches)
        position = decodeString(from: container, for: .position)
        positionType = decodeString(from: container, for: .positionType)
    }
    
    init(from webPlayer: WebPlayerStats.HomeAwayTeams.HomeAwayTeam.Player.Person)
    {
        id = webPlayer.id
        fullName = webPlayer.fullName
        firstName = webPlayer.firstName
        lastName = webPlayer.lastName
        
        if let birthdateString = webPlayer.birthDate
        {
            let dateTimeFormatter = getDateFormatter(for: .webDate)
            birthdate = dateTimeFormatter.date(from: birthdateString)
        }
        
        if let heightString = webPlayer.height,
           heightString.contains("'"),
           let feet = Int(heightString.components(separatedBy: "'")[0]),
           let inches = Int(heightString.components(separatedBy: "' ")[1].components(separatedBy: "\"")[0])
        {
            heightInches = (feet * 12) + inches
        }
        
        weight = webPlayer.weight
        shootsCatches = webPlayer.shootsCatches
        position = webPlayer.primaryPosition?.abbreviation
        positionType = webPlayer.primaryPosition?.type
    }
    
    static func editableColumns() -> [PlayerColumn] {
        return PlayerColumn.allCases
    }
    
    func values() -> [PlayerColumn : Encodable] {
        return [.id: id,
                .fullName: fullName,
                .firstName: firstName,
                .lastName: lastName,
                .birthdate: birthdate,
                .heightInches: heightInches,
                .weight: weight,
                .shootsCatches: shootsCatches,
                .position: position,
                .positionType: positionType]
    }
    
    enum PlayerColumn: String, DatabaseColumn
    {
        case id = "ID"
        case fullName = "FULL_NAME"
        case firstName = "FIRST_NAME"
        case lastName = "LAST_NAME"
        case birthdate = "BIRTHDATE"
        case heightInches = "HEIGHT_INCHES"
        case weight = "WEIGHT"
        case shootsCatches = "SHOOTS_CATCHES"
        case position = "POSITION"
        case positionType = "POSITION_TYPE"
    }
}
