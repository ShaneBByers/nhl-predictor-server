//
//  ModelSkaterStatsGame.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/12/22.
//

import Foundation
import CreateML

enum SkaterModelGameStatsColumn: String, CaseIterable
{
    case goals = "Skater Goals"
    case assists = "Skater Assists"
    case shots = "Skater Shots"
    case ppGoals = "Skater PP Goals"
    case ppAssists = "Skater PP Assists"
    case shGoals = "Skater SH Goals"
    case shAssists = "Skater SH Assists"
    case blockedShots = "Skater Blocked Shots"
    case toiSec = "Skater TOI Seconds"
    case evenToiSec = "Skater Even TOI Seconds"
    case ppToiSec = "Skater PP TOI Seconds"
    case shToiSec = "Skater SH TOI Seconds"
    case faceoffTaken = "Skater Faceoff Taken"
    case faceoffWins = "Skater Faceoff Wins"
    case takeaways = "Skater Takeaways"
    case giveaways = "Skater Giveaways"
    case pim = "Skater PIM"
}

struct SkaterModelGameStats: SkaterModelStats
{
    typealias ColumnType = SkaterModelGameStatsColumn
    
    var gamesAgo: Int?
    var goals: Double
    var assists: Double
    var shots: Double
    var ppGoals: Double
    var ppAssists: Double
    var shGoals: Double
    var shAssists: Double
    var blockedShots: Double
    var toiSec: Double
    var evenToiSec: Double
    var ppToiSec: Double
    var shToiSec: Double
    var faceoffTaken: Double
    var faceoffWins: Double
    var takeaways: Double
    var giveaways: Double
    var pim: Double
    
    init(usingSkaterStats skaterStats: DatabaseSkaterStats, fromGamesAgo ago: Int?)
    {
        gamesAgo = ago
        goals = Double(skaterStats.goals ?? 0)
        assists = Double(skaterStats.assists ?? 0)
        shots = Double(skaterStats.shots ?? 0)
        ppGoals = Double(skaterStats.ppGoals ?? 0)
        ppAssists = Double(skaterStats.ppAssists ?? 0)
        shGoals = Double(skaterStats.shGoals ?? 0)
        shAssists = Double(skaterStats.shAssists ?? 0)
        blockedShots = Double(skaterStats.blockedShots ?? 0)
        toiSec = Double(skaterStats.toiSec ?? 0)
        evenToiSec = Double(skaterStats.evenToiSec ?? 0)
        ppToiSec = Double(skaterStats.ppToiSec ?? 0)
        shToiSec = Double(skaterStats.shToiSec ?? 0)
        faceoffTaken = Double(skaterStats.faceoffTaken ?? 0)
        faceoffWins = Double(skaterStats.faceoffWins ?? 0)
        takeaways = Double(skaterStats.takeaways ?? 0)
        giveaways = Double(skaterStats.giveaways ?? 0)
        pim = Double(skaterStats.pim ?? 0)
    }
    
    init(averagingFromSkaterStats skaterStatsList: [DatabaseSkaterStats])
    {
        let empty = skaterStatsList.isEmpty
        let count = Double(skaterStatsList.count)
        goals = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.goals ?? 0)})) / count
        assists = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.assists ?? 0)})) / count
        shots = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.shots ?? 0)})) / count
        ppGoals = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.ppGoals ?? 0)})) / count
        ppAssists = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.ppAssists ?? 0)})) / count
        shGoals = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.shGoals ?? 0)})) / count
        shAssists = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.shAssists ?? 0)})) / count
        blockedShots = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.blockedShots ?? 0)})) / count
        toiSec = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.toiSec ?? 0)})) / count
        evenToiSec = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.evenToiSec ?? 0)})) / count
        ppToiSec = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.ppToiSec ?? 0)})) / count
        shToiSec = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.shToiSec ?? 0)})) / count
        faceoffTaken = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.faceoffTaken ?? 0)})) / count
        faceoffWins = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.faceoffWins ?? 0)})) / count
        takeaways = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.takeaways ?? 0)})) / count
        giveaways = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.giveaways ?? 0)})) / count
        pim = empty ? 0 : Double(skaterStatsList.reduce(0, {$0 + ($1.pim ?? 0)})) / count
    }
    
    static func addColumns(to dataTable: inout MLDataTable,
                          using skaterStats: [SkaterModelGameStats],
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
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.toiSec }), named: getColumnString(.toiSec, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.evenToiSec }), named: getColumnString(.evenToiSec, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.ppToiSec }), named: getColumnString(.ppToiSec, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.shToiSec }), named: getColumnString(.shToiSec, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.faceoffTaken }), named: getColumnString(.faceoffTaken, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.faceoffWins }), named: getColumnString(.faceoffWins, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.takeaways }), named: getColumnString(.takeaways, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.giveaways }), named: getColumnString(.giveaways, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.pim }), named: getColumnString(.pim, prefix: prefix, suffix: suffix))
    }
}
