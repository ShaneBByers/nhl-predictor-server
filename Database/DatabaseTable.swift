//
//  DatabaseTable.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/21/22.
//

import Foundation

enum DateType
{
    case dbDate
    case dbDateTime
    case webDate
    case webDateTime
}

protocol DatabaseColumn: Codable, CodingKey, CaseIterable, RawRepresentable, Hashable {}

protocol DatabaseTable: Codable
{
    associatedtype ColumnType: DatabaseColumn where ColumnType.RawValue == String
    
    static var tableName: String { get }
    
    init()
    
    init(from decoder: Decoder)
    
    static func editableColumns() -> [ColumnType]
    
    func values() -> [ColumnType:Encodable]
}

extension DatabaseTable
{
    func decodeString(from container: KeyedDecodingContainer<ColumnType>?, for col: ColumnType) -> String?
    {
        return try? container?.decode(String.self, forKey: col)
    }
    
    func decodeInt(from container: KeyedDecodingContainer<ColumnType>?, for col: ColumnType) -> Int?
    {
        var returnInt: Int?
        if let decodedString = try? container?.decode(String.self, forKey: col)
        {
            returnInt = Int(decodedString)
        }
        
        return returnInt
    }
    
    func decodeDate(from container: KeyedDecodingContainer<ColumnType>?, for col: ColumnType, ofType dateType: DateType) -> Date?
    {
        var returnDate: Date?
        if let decodedString = try? container?.decode(String.self, forKey: col)
        {
            let dateFormatter = getDateFormatter(for: dateType)
            returnDate = dateFormatter.date(from: decodedString)
        }
        
        return returnDate
    }
    
    func decodeDateTime(from container: KeyedDecodingContainer<ColumnType>?, for col: ColumnType, ofType dateType: DateType) -> Date?
    {
        var returnDateTime: Date?
        if let decodedString = try? container?.decode(String.self, forKey: col)
        {
            let dateFormatter = getDateFormatter(for: dateType)
            returnDateTime = dateFormatter.date(from: decodedString)
        }
        
        return returnDateTime
    }
    
    func getDateFormatter(for dateType: DateType) -> DateFormatter
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        switch dateType
        {
            case .dbDate, .webDate:
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            case .dbDateTime:
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            case .webDateTime:
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        }
        return dateFormatter
    }
    
    func getTimeOnIceSeconds(from timeString: String?) -> Int?
    {
        if let timeString = timeString,
           timeString.contains(":"),
           let minutes = Int(timeString.components(separatedBy: ":")[0]),
           let seconds = Int(timeString.components(separatedBy: ":")[1])
        {
            return (minutes * 60) + seconds
        }
        
        return nil
    }
}
