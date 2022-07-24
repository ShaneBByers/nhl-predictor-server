//
//  WhereOperation.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/21/22.
//

import Foundation

struct Where
{
    var column: String
    var operation: String
    var value: String
    
    private static let eq = "="
    private static let neq = "!="
    private static let lt = "<"
    private static let lte = "<="
    private static let gt = ">"
    private static let gte = ">="
    
    init<TableT: DatabaseTable>(_ table: TableT.Type, _ col: TableT.ColumnType, _ comparison: (Int, Int) -> Bool, _ comparableValue: Int?)
    {
        column = col.rawValue
        operation = Where.getOperationString(comparison)
        value = Select.getDatabaseString(comparableValue)
    }
    
    init<TableT: DatabaseTable>(_ table: TableT.Type, _ col: TableT.ColumnType, _ comparison: (String, String) -> Bool, _ comparableValue: String?)
    {
        column = col.rawValue
        operation = Where.getOperationString(comparison)
        value = Select.getDatabaseString(comparableValue)
    }
    
    private static func getOperationString(_ comparison: (Int, Int) -> Bool) -> String
    {
        if comparison(1, 2)
        {
            if (comparison(1, 1))
            {
                return lte
            }
            else
            {
                return lt
            }
        }
        else if comparison(2, 1)
        {
            if comparison(2, 2)
            {
                return gte
            }
            else
            {
                return gt
            }
        }
        else if comparison(1, 1)
        {
            return eq
        }
        else
        {
            return neq
        }
    }
    
    private static func getOperationString(_ comparison: (String, String) -> Bool) -> String
    {
        if comparison("a", "b")
        {
            if comparison("a", "a")
            {
                return lte
            }
            else
            {
                return lt
            }
        }
        else if comparison("b", "a")
        {
            if comparison("b", "b")
            {
                return gte
            }
            else
            {
                return gt
            }
        }
        else if comparison("a", "a")
        {
            return eq
        }
        else
        {
            return neq
        }
    }
}
