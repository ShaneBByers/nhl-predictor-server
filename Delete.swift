//
//  Delete.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/4/22.
//

import Foundation

struct Delete
{
    func deleteAllData()
    {
        logger.info("Deleting: All Data")
        deleteSkaterStatsAndGoalieStatsAndPlayers()
        deleteTeamStats()
        deleteGames()
        deleteSeasons()
        deleteTeams()
        deleteDivisions()
        deleteConferences()
        logger.info("Finished deleting: All Data")
    }
    
    func deleteSkaterStatsAndGoalieStatsAndPlayers()
    {
        logger.info("Deleting: Skater Stats AND Goalie Stats AND Players")
        logger.info("Deleting skater stats from database.")
        if let deletedSkaterStats = Database.delete(from: DatabaseSkaterStats.self, where: [Where(DatabaseSkaterStats.self, .gameId, >, 0)])
        {
            logger.info("Deleted \(deletedSkaterStats) skater stats from database.")
        }
        if let deletedGoalieStats = Database.delete(from: DatabaseGoalieStats.self, where: [Where(DatabaseGoalieStats.self, .gameId, >, 0)])
        {
            logger.info("Deleted \(deletedGoalieStats) goalie stats from database.")
        }
        logger.info("Deleting players from database.")
        if let deletedPlayers = Database.delete(from: DatabasePlayer.self, where: [Where(DatabasePlayer.self, .id, >, 0)])
        {
            logger.info("Deleted \(deletedPlayers) players from database.")
        }
        logger.info("Finished deleting: Skater Stats AND Goalie Stats AND Players")
    }
    
    func deleteTeamStats()
    {
        logger.info("Deleting: Team Stats")
        logger.info("Deleting team stats from database.")
        if let deleted = Database.delete(from: DatabaseTeamStats.self, where: [Where(DatabaseTeamStats.self, .gameId, >, 0)])
        {
            logger.info("Deleted \(deleted) team stats from database.")
        }
        logger.info("Finished deleting: Team Stats")
    }
    
    func deleteGames()
    {
        logger.info("Deleting: Games")
        logger.info("Deleting games from database.")
        if let deleted = Database.delete(from: DatabaseGame.self, where: [Where(DatabaseGame.self, .id, >, 0)])
        {
            logger.info("Deleted \(deleted) games from database.")
        }
        logger.info("Finished deleting: Games")
    }
    
    func deleteSeasons()
    {
        logger.info("Deleting: Seasons")
        logger.info("Deleting seasons from database.")
        if let deleted = Database.delete(from: DatabaseSeason.self, where: [Where(DatabaseSeason.self, .id, >, 0)])
        {
            logger.info("Deleted \(deleted) seasons from database.")
        }
        logger.info("Finished deleting: Seasons")
    }
    
    func deleteTeams()
    {
        logger.info("Deleting: Teams")
        logger.info("Deleting teams from database.")
        if let deleted = Database.delete(from: DatabaseTeam.self, where: [Where(DatabaseTeam.self, .id, >, 0)])
        {
            logger.info("Deleted \(deleted) teams from database.")
        }
        logger.info("Finished deleting: Teams")
    }
    
    func deleteDivisions()
    {
        logger.info("Deleting: Divisions")
        logger.info("Deleting divisions from database.")
        if let deleted = Database.delete(from: DatabaseDivision.self, where: [Where(DatabaseDivision.self, .id, >, 0)])
        {
            logger.info("Deleted \(deleted) divisions from database.")
        }
        logger.info("Finished deleting: Divisions")
    }
    
    func deleteConferences()
    {
        logger.info("Deleting: Conferences")
        logger.info("Deleting conferences from database.")
        if let deleted = Database.delete(from: DatabaseConference.self, where: [Where(DatabaseConference.self, .id, >, 0)])
        {
            logger.info("Deleted \(deleted) conferences from database.")
        }
        logger.info("Finished deleting: Conferences")
    }
}
