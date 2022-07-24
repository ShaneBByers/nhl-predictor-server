//
//  ModelData.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/11/22.
//

import Foundation
import CreateML

struct SkaterModelData
{
    var previousGamesSkaterData: [SkaterModelGameStats]
    var seasonAverageSkaterData: SkaterModelGameStats
    
    var previousGamesTeamData: [SkaterModelTeamGameStats]
    var seasonAverageTeamData: SkaterModelTeamGameStats
    
    var expectedStats: SkaterModelExpectedStats
    
    init(forGame gameId: Int,
         seasonSkaterStats seasonSkaterStatsList: [DatabaseSkaterStats],
         seasonTeamStats seasonTeamStatsList: [DatabaseTeamStats],
         expected actual: DatabaseSkaterStats)
    {
        previousGamesSkaterData = []
        var gamesAgo = 1
        let previousSkaterStatsList = seasonSkaterStatsList.filter({ $0.gameId ?? 0 < gameId }).prefix(10)
        for previousSkaterStats in previousSkaterStatsList
        {
            previousGamesSkaterData.append(SkaterModelGameStats(usingSkaterStats: previousSkaterStats, fromGamesAgo: gamesAgo))
            gamesAgo += 1
        }
        seasonAverageSkaterData = SkaterModelGameStats(averagingFromSkaterStats: seasonSkaterStatsList)
        
        previousGamesTeamData = []
        gamesAgo = 1
        let previousTeamStatsList = seasonTeamStatsList.filter({ $0.gameId ?? 0 < gameId }).prefix(10)
        for previousTeamStats in previousTeamStatsList
        {
            previousGamesTeamData.append(SkaterModelTeamGameStats(usingTeamStats: previousTeamStats, fromGamesAgo: gamesAgo))
            gamesAgo += 1
        }
        seasonAverageTeamData = SkaterModelTeamGameStats(averagingFromTeamStats: seasonTeamStatsList)
        
        expectedStats = SkaterModelExpectedStats(using: actual)
    }
}
