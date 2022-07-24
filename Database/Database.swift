//
//  WebServerConnector.swift
//  PredictorServer
//
//  Created by Shane Byers on 2/19/22.
//

import Foundation
import OSLog

struct Database
{
    private static let baseUrl = "http://www.nhl-predictor.com/"
    private static let transactionPHP = "transaction.php"
    private static let selectPHP = "select.php"
    
    private static let logger = Logger(subsystem: Logger.id, category: Logger.Category.database.rawValue)
    
    @discardableResult static func execute(_ transaction: Transaction) -> Int?
    {
        return getResponse(from: transactionPHP, using: transaction)
    }
    
    @discardableResult static func insert<TableT: DatabaseTable>(values rows: [TableT]) -> Int?
    {
        var transaction = Transaction()
        transaction.insert(values: rows)
        return execute(transaction)
    }
    
    @discardableResult static func update<TableT: DatabaseTable>(set row: TableT, on cols: [TableT.ColumnType], where whereClauses: [Where]) -> Int?
    {
        var transaction = Transaction()
        transaction.update(set: row, on: cols, where: whereClauses)
        return execute(transaction)
    }
    
    @discardableResult static func delete<TableT: DatabaseTable>(from table: TableT.Type, where whereClauses: [Where]) -> Int?
    {
        var transaction = Transaction()
        transaction.delete(from: table, where: whereClauses)
        return execute(transaction)
    }
    
    static func select<TableT: DatabaseTable>(_ select: Select) -> [TableT]?
    {
        return getResponse(from: selectPHP, using: select)
    }
    
    static func select<TableT: DatabaseTable>(_ table: TableT.Type) -> [TableT]?
    {
        return select(Select(table))
    }
    
    static func select<TableT: DatabaseTable>(_ table: TableT.Type, where whereClause: Where) -> [TableT]?
    {
        return select(Select(table, where: [whereClause]))
    }
    
    static func select<TableT: DatabaseTable>(_ table: TableT.Type, where whereClause: [Where]) -> [TableT]?
    {
        return select(Select(table, where: whereClause))
    }
    
    static func select<TableT: DatabaseTable>(_ table: TableT.Type, on cols: [TableT.ColumnType], where whereClauses: [Where]) -> [TableT]?
    {
        return select(Select(table, on: cols, where: whereClauses))
    }
    
    private static func getResponse<RequestT: DatabaseRequest, ReturnT: Decodable>(from filename: String, using request: RequestT) -> ReturnT?
    {
        if let url = URL(string: baseUrl + filename)
        {
            logger.debug("\(request.queryList)")
            let encoder = JSONEncoder()
            if let body = try? encoder.encode(request)
            {
                if let jsonResponse = executePostRequest(url, with: body)
                {
                    let decoder = JSONDecoder()
                    if let decoded = try? decoder.decode(ReturnT.self, from: jsonResponse)
                    {
                        return decoded
                    }
                    else
                    {
                        logger.debug("\(jsonResponse)")
                    }
                }
            }
        }
        return nil
    }
    
    private static func executePostRequest(_ url: URL, with body: Data) -> Data?
    {
        var jsonResponse: Data? = nil
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request)
        { data, response, error in
            jsonResponse = data
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return jsonResponse
    }
}
