//
//  CreateModel.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/10/22.
//

import Foundation
import CreateML

enum DataTableType: Double
{
    case training
    case evaluation = 0.2
}

struct SkaterModel
{
    var dataTables: [SkaterModelExpectedStatsColumn:[DataTableType:MLDataTable]] = [:]
    var regressors: [SkaterModelExpectedStatsColumn:MLRegressor] = [:]
    var evaluationResults: [SkaterModelExpectedStatsColumn:MLRegressorMetrics] = [:]
    
    mutating func create(seed: Int)
    {
        logger.log("Directory: \(FileManager.default.currentDirectoryPath)")
        logger.log("Creating Skater Model data tables.")
        let skaterModelDataList = getSkaterModelDataList()
        
        let baseDataTable = getSkaterDataTable(using: skaterModelDataList)
        
        for column in SkaterModelExpectedStatsColumn.allCases
        {
            logger.log("Creating evaluation and training tables for: \(column.rawValue).")
            let columnDataTable = getDataTable(from: baseDataTable, on: column)
            let (evaluationTable, trainingTable) = columnDataTable.randomSplit(by: DataTableType.evaluation.rawValue, seed: seed)
            dataTables[column] =
            [
                .evaluation: evaluationTable,
                .training: trainingTable
            ]
            logger.log("Finished creating evaluation and training tables for: \(column.rawValue).")
        }
        logger.log("Finished creating Skater Model data tables.")
    }
    
    mutating func train()
    {
        logger.log("Training Skater Model data tables.")
        for (column, dataTableMap) in dataTables
        {
            if let trainingTable = dataTableMap[.training]
            {
                logger.log("Training data table for: \(column.rawValue).")
                if let regressor = try? MLRegressor(trainingData: trainingTable, targetColumn: column.rawValue)
                {
                    regressors[column] = regressor
                }
                logger.log("Finished training data table for: \(column.rawValue).")
            }
        }
        logger.log("Finished training Skater Model data tables.")
    }
    
    mutating func evaluate()
    {
        logger.log("Evaluating Skater Model data tables.")
        for (column, regressor) in regressors
        {
            if let dataTable = dataTables[column]?[.evaluation]
            {
                logger.log("Evaluating data table for: \(column.rawValue).")
                let evaluation = regressor.evaluation(on: dataTable)
                evaluationResults[column] = evaluation
                logger.log("Finished evaluating data table for: \(column.rawValue).")
            }
        }
        logger.log("Finished evaluating Skater Model data tables.")
    }
    
    func save(inDirectory directory: String)
    {
        logger.log("Saving Skater Model data tables.")
        for (column, regressor) in regressors
        {
            let modelName = getModelName(using: column)
            let description = "Regression model with \(regressor.featureColumns.count) columns predicting: \(column.rawValue)."
            let metadata = MLModelMetadata(author: "Shane Byers",
                                           shortDescription: description,
                                           version: "0.1")
            do
            {
                let filepath = directory + "\(modelName).mlmodel"
                try regressor.write(toFile: filepath, metadata: metadata)
            }
            catch
            {
                logger.error("ERROR SAVING REGRESSION MODEL: \(modelName)")
            }
        }
        logger.log("Finished saving Skater Model data tables.")
    }
    
    private func getSkaterModelDataList() -> [SkaterModelData]
    {
        var skaterModelDataList: [SkaterModelData] = []
        
        logger.log("Attempting to get all Skater and Team Stats data from database.")
        let skaterStatsWhereClause = [
            Where(DatabaseSkaterStats.self, .gameId, >=, 2005000000),
            Where(DatabaseSkaterStats.self, .gameId, <=, 2006000000)
        ]
        let teamStatsWhereClause = [
            Where(DatabaseTeamStats.self, .gameId, >=, 2005000000),
            Where(DatabaseTeamStats.self, .gameId, >=, 2006000000)
        ]
        if var skaterStatsList = Database.select(DatabaseSkaterStats.self,
                                                 where: skaterStatsWhereClause),
           var teamStatsList = Database.select(DatabaseTeamStats.self,
                                               where: teamStatsWhereClause)
        {
            logger.log("Successfully read \(skaterStatsList.count) skater stats and \(teamStatsList.count) team stats from database.")
            skaterStatsList.sort(by: { $0.gameId ?? 0 > $1.gameId ?? 0 })
            teamStatsList.sort(by: { $0.gameId ?? 0 > $1.gameId ?? 0})
            var playerIdToSkaterStatsDict: [Int:[DatabaseSkaterStats]] = [:]
            var playerIdToTeamStatsDict: [Int:[DatabaseTeamStats]] = [:]
            for skaterStats in skaterStatsList
            {
                if let playerId = skaterStats.playerId
                {
                    if var currentList = playerIdToSkaterStatsDict[playerId]
                    {
                        currentList.append(skaterStats)
                        playerIdToSkaterStatsDict[playerId] = currentList
                    }
                    else
                    {
                        playerIdToSkaterStatsDict[playerId] = [skaterStats]
                    }
                }
            }
            for teamStats in teamStatsList
            {
                if let teamId = teamStats.teamId
                {
                    if var currentList = playerIdToTeamStatsDict[teamId]
                    {
                        currentList.append(teamStats)
                    }
                    else
                    {
                        playerIdToTeamStatsDict[teamId] = [teamStats]
                    }
                }
            }
            logger.log("Successfully sorted skater stats and team stats into appropriate dictionaries.")
            for skaterStats in skaterStatsList
            {
                if let gameId = skaterStats.gameId,
                   let teamId = skaterStats.teamId,
                   let playerId = skaterStats.playerId,
                   let seasonSkaterStats = playerIdToSkaterStatsDict[playerId],
                   let seasonTeamStats = playerIdToTeamStatsDict[teamId]
                {
                    let skaterModelData = SkaterModelData(forGame: gameId,
                                                          seasonSkaterStats: seasonSkaterStats,
                                                          seasonTeamStats: seasonTeamStats,
                                                          expected: skaterStats)
                    skaterModelDataList.append(skaterModelData)
                }
            }
            logger.log("Successfully created model data objects.")
        }
        
        return skaterModelDataList
    }
    
    private func getSkaterDataTable(using skaterModelDataList: [SkaterModelData]) -> MLDataTable
    {
        var dataTable = MLDataTable()
        
        SkaterModelGameStats.addColumns(to: &dataTable,
                                        using: skaterModelDataList.map { $0.seasonAverageSkaterData },
                                        prefix: "Season Average ")
        
        SkaterModelExpectedStats.addColumns(to: &dataTable,
                                            using: skaterModelDataList.map { $0.expectedStats })
        
        logger.log("Successfully create model data table.")
        
        return dataTable
    }
    
    private func getDataTable(from dataTable: MLDataTable, on column: SkaterModelExpectedStatsColumn) -> MLDataTable
    {
        let expectedColumnNames = SkaterModelExpectedStatsColumn.allCases.map { $0.rawValue }
        
        let baseColumnNames = dataTable.columnNames
        
        let newColumnNames = baseColumnNames.filter { !expectedColumnNames.contains($0) || $0 == column.rawValue }
        
        return dataTable[newColumnNames]
    }
    
    private func getModelName(using column: SkaterModelExpectedStatsColumn) -> String
    {
        switch column
        {
            case .goals: return "SkaterGoalsModel"
            case .assists: return "SkaterAssistsModel"
            case .ppGoals: return "SkaterPPGoalsModel"
            case .ppAssists: return "SkaterPPAssistsModel"
            case .shGoals: return "SkaterSHGoalsModel"
            case .shAssists: return "SkaterSHAssistsModel"
            case .shots: return "SkaterShotsModel"
            case .blockedShots: return "SkaterBlockedShotsModel"
        }
    }
}
