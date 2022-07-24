//
//  TransactionRequest.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/26/22.
//

import Foundation

struct Transaction: DatabaseRequest
{
    var databaseLogin = DatabaseLogin()
    var queryList: [String] = []
    
    mutating public func insert<TableT: DatabaseTable>(values rows: [TableT])
    {
        if !rows.isEmpty
        {
            let cols = TableT.editableColumns()
            
            var query = "INSERT INTO \(TableT.tableName) ("
            for col in cols
            {
                query += "\(col.rawValue), "
            }
            query.removeLast(2)
            query += ") VALUES "
            for row in rows
            {
                query += "("
                let valueDict = row.values()
                for col in cols
                {
                    if let encodableValue = valueDict[col]
                    {
                        let databaseString = Transaction.getDatabaseString(encodableValue)
                        query += "\(databaseString), "
                    }
                }
                query.removeLast(2)
                query += "), "
            }
            query.removeLast(2)
            query += ";"
            queryList.append(query)
        }
    }
    
    mutating public func update<TableT: DatabaseTable>(set row: TableT, on cols: [TableT.ColumnType], where whereClauses: [Where])
    {
        var query = "UPDATE \(TableT.tableName) SET "
        let valueDict = row.values()
        for col in cols
        {
            if let encodableValue = valueDict[col]
            {
                let databaseString = Transaction.getDatabaseString(encodableValue)
                query += "\(col.rawValue) = \(databaseString), "
            }
            query.removeLast(2)
            query += " "
            query += Transaction.getWhereString(whereClauses)
            query += ";"
            queryList.append(query)
        }
    }
    
    mutating public func delete<TableT: DatabaseTable>(from table: TableT.Type, where whereClauses: [Where])
    {
        var query = "DELETE FROM \(table.tableName) "
        query += Transaction.getWhereString(whereClauses)
        query += ";"
        queryList.append(query)
    }
}
