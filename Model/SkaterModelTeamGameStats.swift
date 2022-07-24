//
//  ModelTeamStatsGame.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/12/22.
//

import Foundation
import CreateML

enum SkaterModelTeamGameStatsColumn: String, CaseIterable
{
    case goals = "Team Goals"
    case shots = "Team Shots"
    case ppGoals = "Team PP Goals"
    case ppOpportunities = "Team PP Opportunities"
    case blockedShots = "Team Blocked Shots"
    case pim = "Team PIM"
    case takeaways = "Team Takeaways"
    case giveaways = "Team Giveaways"
    case hits = "Team Hits"
}

struct SkaterModelTeamGameStats: SkaterModelStats
{
    typealias ColumnType = SkaterModelTeamGameStatsColumn
    
    var gamesAgo: Int?
    var goals: Double
    var shots: Double
    var ppGoals: Double
    var ppOpportunities: Double
    var blockedShots: Double
    var pim: Double
    var takeaways: Double
    var giveaways: Double
    var hits: Double
    
    init(usingTeamStats teamStats: DatabaseTeamStats, fromGamesAgo ago: Int?)
    {
        gamesAgo = ago
        goals = Double(teamStats.goals ?? 0)
        shots = Double(teamStats.shots ?? 0)
        ppGoals = Double(teamStats.ppGoals ?? 0)
        ppOpportunities = Double(teamStats.ppOpportunities ?? 0)
        blockedShots = Double(teamStats.blockedShots ?? 0)
        pim = Double(teamStats.pim ?? 0)
        takeaways = Double(teamStats.takeaways ?? 0)
        giveaways = Double(teamStats.giveaways ?? 0)
        hits = Double(teamStats.hits ?? 0)
    }
    
    init(averagingFromTeamStats teamStatsList: [DatabaseTeamStats])
    {
        let empty = teamStatsList.isEmpty
        let count = Double(teamStatsList.count)
        goals = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.goals ?? 0)})) / count
        shots = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.shots ?? 0)})) / count
        ppGoals = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.ppGoals ?? 0)})) / count
        ppOpportunities = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.ppOpportunities ?? 0)})) / count
        blockedShots = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.blockedShots ?? 0)})) / count
        pim = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.pim ?? 0)})) / count
        takeaways = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.takeaways ?? 0)})) / count
        giveaways = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.giveaways ?? 0)})) / count
        hits = empty ? 0 : Double(teamStatsList.reduce(0, {$0 + ($1.hits ?? 0)})) / count
    }
    
    static func addColumns(to dataTable: inout MLDataTable,
                           using skaterStats: [SkaterModelTeamGameStats],
                           prefix: String? = nil,
                           suffix: String? = nil)
    {
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.goals }), named: getColumnString(.goals, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.shots }), named: getColumnString(.shots, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.ppGoals }), named: getColumnString(.ppGoals, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.ppOpportunities }), named: getColumnString(.ppOpportunities, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.blockedShots }), named: getColumnString(.blockedShots, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.pim }), named: getColumnString(.pim, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.takeaways }), named: getColumnString(.takeaways, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.giveaways }), named: getColumnString(.giveaways, prefix: prefix, suffix: suffix))
        dataTable.addColumn(MLDataColumn(skaterStats.map { $0.hits }), named: getColumnString(.hits, prefix: prefix, suffix: suffix))
    }
}
