//
//  SkaterModelStats.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/18/22.
//

import Foundation
import CreateML

protocol SkaterModelStats
{
    associatedtype ColumnType: RawRepresentable
    
    static func addColumns(to dataTable: inout MLDataTable,
                           using skaterStats: [Self],
                           prefix: String?,
                           suffix: String?)
}

extension SkaterModelStats
{
    static func getColumnString(_ col: ColumnType,
                                        prefix: String? = nil,
                                        suffix: String? = nil) -> String
    {
        return "\(prefix ?? "")\(col.rawValue)\(suffix ?? "")"
    }
}
