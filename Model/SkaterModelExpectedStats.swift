//
//  ModelExpectedSkaterStats.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/16/22.
//

import Foundation
import CreateML

enum SkaterModelExpectedStatsColumn: String, CaseIterable
{
    case goals = "Expected Goals"
    case assists = "Expected Assists"
    case shots = "Expected Shots"
    case ppGoals = "Expected PP Goals"
    case ppAssists = "Expected PP Assists"
    case shGoals = "Expected SH Goals"
    case shAssists = "Expected SH Assists"
    case blockedShots = "Expected Blocked Shots"
}

struct SkaterModelExpectedStats: SkaterModelStats
{
    typealias ColumnType = SkaterModelExpectedStatsColumn
    
    var goals: Double
    var assists: Double
    var shots: Double
    var ppGoals: Double
    var ppAssists: Double
    var shGoals: Double
    var shAssists: Double
    var blockedShots: Double
    
    init(using skaterStats: DatabaseSkaterStats)
    {
        goals = Double(skaterStats.goals ?? 0)
        assists = Double(skaterStats.assists ?? 0)
        shots = Double(skaterStats.shots ?? 0)
        ppGoals = Double(skaterStats.ppGoals ?? 0)
        ppAssists = Double(skaterStats.ppAssists ?? 0)
        shGoals = Double(skaterStats.shGoals ?? 0)
        shAssists = Double(skaterStats.shAssists ?? 0)
        blockedShots = Double(skaterStats.blockedShots ?? 0)
    }
    
    static func addColumns(to dataTable: inout MLDataTable,
                          using skaterStats: [SkaterModelExpectedStats],
                          prefix: String? = nil,
                          suffix: String? = nil)
    {
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.goals }), named: getColumnString(.goals, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.assists }), named: getColumnString(.assists, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.shots }), named: getColumnString(.shots, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.ppGoals }), named: getColumnString(.ppGoals, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.ppAssists }), named: getColumnString(.ppAssists, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.shGoals }), named: getColumnString(.shGoals, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.shAssists }), named: getColumnString(.shAssists, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.blockedShots }), named: getColumnString(.blockedShots, prefix: prefix, suffix: suffix))
    }
}
