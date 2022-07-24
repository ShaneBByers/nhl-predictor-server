//
//  Select.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/3/22.
//

import Foundation

struct Select: DatabaseRequest
{
    var databaseLogin = DatabaseLogin()
    var queryList: [String] = []
    
    init<TableT: DatabaseTable>(_ table: TableT.Type)
    {
        self.init(table, on: nil, where: nil)
    }
    
    init<TableT: DatabaseTable>(_ table: TableT.Type, where whereClause: [Where])
    {
        self.init(table, on: nil, where: whereClause)
    }
    
    init<TableT: DatabaseTable>(_ table: TableT.Type, on cols: [TableT.ColumnType]?, where whereClauses: [Where]?)
    {
        var query = "SELECT "
        if let cols = cols
        {
            query += "("
            for col in cols
            {
                query += "\(col.rawValue), "
            }
            query.removeLast(2)
            query += ")"
        }
        else
        {
            query += "*"
        }
        query += " FROM \(TableT.tableName)"
        if let whereClauses = whereClauses
        {
            query += " "
            query += Select.getWhereString(whereClauses)
        }
        query += ";"
        queryList.append(query)
    }
}
