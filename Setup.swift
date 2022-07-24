//
//  Initialization.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/3/22.
//

import Foundation

struct Setup
{
    func setupAllData()
    {
        logger.info("Setting up: All Data")
        setupConferences()
        setupDivisions()
        setupTeams()
        setupSeasons()
        setupGames()
        setupTeamStats()
        setupPlayersAndSkaterStatsAndGoalieStats()
        logger.info("Finished setting up: All Data")
    }
    
    func setupConferences()
    {
        logger.info("Setting up: Conferences")
        if let webConferenceList = WebRequest.getData(WebConferenceList())
        {
            if let webConferences = webConferenceList.conferences
            {
                logger.info("Read \(webConferences.count) conferences from web.")
                var databaseConferences: [DatabaseConference] = []
                for webConference in webConferences {
                    databaseConferences.append(DatabaseConference(from: webConference))
                }
                logger.info("Inserting \(databaseConferences.count) conferences to database.")
                if let inserted = Database.insert(values: databaseConferences)
                {
                    logger.info("Inserted \(inserted) conferences to database.")
                }
            }
        }
        logger.info("Finished setting up: Conferences")
    }
    
    func setupDivisions()
    {
        logger.info("Setting up: Divisions")
        if let webDivisionList = WebRequest.getData(WebDivisionList())
        {
            if let webDivisions = webDivisionList.divisions
            {
                logger.info("Red \(webDivisions.count) divisions from web.")
                var databaseDivisions: [DatabaseDivision] = []
                for webDivision in webDivisions {
                    databaseDivisions.append(DatabaseDivision(from: webDivision))
                }
                logger.info("Inserting \(databaseDivisions.count) divisions to database.")
                if let inserted = Database.insert(values: databaseDivisions)
                {
                    logger.info("Inserted \(inserted) divisions to database.")
                }
            }
        }
        logger.info("Finished setting up: Divisions")
    }
    
    func setupTeams()
    {
        logger.info("Setting up: Teams")
        if let webTeamList = WebRequest.getData(WebTeamList())
        {
            if let webTeams = webTeamList.teams
            {
                logger.info("Read \(webTeams.count) teams from web.")
                var databaseTeams: [DatabaseTeam] = []
                for webTeam in webTeams
                {
                    databaseTeams.append(DatabaseTeam(from: webTeam))
                }
                logger.info("Inserting \(databaseTeams.count) teams to database.")
                if let inserted = Database.insert(values: databaseTeams)
                {
                    logger.info("Inserted \(inserted) teams to database.")
                }
            }
        }
        logger.info("Finished setting up: Teams")
    }
    
    func setupSeasons()
    {
        logger.info("Setting up: Seasons")
        if let webSeasonList = WebRequest.getData(WebSeasonList())
        {
            if let webSeasons = webSeasonList.seasons
            {
                logger.info("Read \(webSeasons.count) seasons from web.")
                var databaseSeasons: [DatabaseSeason] = []
                for webSeason in webSeasons
                {
                    databaseSeasons.append(DatabaseSeason(from: webSeason))
                }
                logger.info("Inserting \(databaseSeasons.count) seasons to database.")
                if let inserted = Database.insert(values: databaseSeasons)
                {
                    logger.info("Inserted \(inserted) seasons to database.")
                }
            }
        }
        logger.info("Finished setting up: Seasons")
    }
    
    func setupGames()
    {
        logger.info("Setting up: Games")
        if let seasons = Database.select(DatabaseSeason.self),
           let teams = Database.select(DatabaseTeam.self)
        {
            var teamIds = teams.map { $0.id }
            var insertTransaction = Transaction()
            for season in seasons
            {
                if let seasonId = season.id
                {
                    logger.info("Fetching games for season with ID: \(seasonId).")
                    if let webGamesList = WebRequest.getData(WebGameList(forSeason: seasonId)),
                        let webGamesDates = webGamesList.dates
                    {
                        logger.info("Read \(webGamesDates.count) dates for season with ID: \(seasonId).")
                        for webGameDate in webGamesDates
                        {
                            if let webGames = webGameDate.games,
                                let date = webGameDate.date
                            {
                                logger.info("Read \(webGames.count) games for date: \(date)")
                                var databaseGames: [DatabaseGame] = []
                                for webGame in webGames
                                {
                                    if let gameType = webGame.gameType,
                                       gameType == "R" || gameType == "P"
                                    {
                                        let databaseGame = DatabaseGame(from: webGame)
                                        databaseGames.append(databaseGame)
                                        
                                        if let homeTeamId = databaseGame.homeTeamId,
                                           !teamIds.contains(homeTeamId)
                                        {
                                            if let newTeamList = WebRequest.getData(WebTeamList(forTeam: homeTeamId)),
                                               let newTeams = newTeamList.teams
                                            {
                                                var databaseTeams: [DatabaseTeam] = []
                                                for newTeam in newTeams
                                                {
                                                    let databaseTeam = DatabaseTeam(from: newTeam)
                                                    databaseTeams.append(databaseTeam)
                                                    teamIds.append(databaseTeam.id)
                                                }
                                                insertTransaction.insert(values: databaseTeams)
                                            }
                                        }
                                        
                                        if let awayTeamId = databaseGame.awayTeamId,
                                           !teamIds.contains(awayTeamId)
                                        {
                                            if let newTeamList = WebRequest.getData(WebTeamList(forTeam: awayTeamId)),
                                               let newTeams = newTeamList.teams
                                            {
                                                var databaseTeams: [DatabaseTeam] = []
                                                for newTeam in newTeams
                                                {
                                                    let databaseTeam = DatabaseTeam(from: newTeam)
                                                    databaseTeams.append(databaseTeam)
                                                    teamIds.append(databaseTeam.id)
                                                }
                                                insertTransaction.insert(values: databaseTeams)
                                            }
                                        }
                                    }
                                }
                                logger.info("Adding \(databaseGames.count) games to insert transaction.")
                                insertTransaction.insert(values: databaseGames)
                            }
                        }
                    }
                }
            }
            logger.info("Executing \(insertTransaction.queryList.count) inserts into database.")
            if let inserted = Database.execute(insertTransaction)
            {
                logger.info("Inserted \(inserted) games to database.")
            }
        }
        logger.info("Finished setting up: Games")
    }
    
    func setupTeamStats()
    {
        logger.info("Setting up: Team Stats")
        if let seasons = Database.select(DatabaseSeason.self)
        {
            for season in seasons
            {
                if let seasonId = season.id
                {
                    if let games = Database.select(DatabaseGame.self, where: Where(DatabaseGame.self, .seasonId, ==, seasonId))
                    {
                        var insertTeamStats: [DatabaseTeamStats] = []
                        for game in games
                        {
                            if let gameId = game.id
                            {
                                logger.info("Fetching team stats for game with ID: \(gameId)")
                                if let webTeamStats = WebRequest.getData(WebTeamStats(forGame: gameId)),
                                   let homeTeamStats = webTeamStats.teams?.home,
                                   let awayTeamStats = webTeamStats.teams?.away
                                {
                                    insertTeamStats.append(DatabaseTeamStats(from: homeTeamStats, usingGameId: gameId))
                                    insertTeamStats.append(DatabaseTeamStats(from: awayTeamStats, usingGameId: gameId))
                                }
                            }
                        }
                        logger.info("Inserting \(insertTeamStats.count) team stats to database.")
                        if let inserted = Database.insert(values: insertTeamStats)
                        {
                            logger.info("Inserted \(inserted) team stats to database.")
                        }
                    }
                }
            }

        }
        logger.info("Finished setting up: Team Stats")
    }
    
    func setupPlayersAndSkaterStatsAndGoalieStats()
    {
        logger.info("Setting up: Players AND Skater Stats AND Goalie Stats")
        if let players = Database.select(DatabasePlayer.self)
        {
            var playerIds = players.map { $0.id }
            if let seasons = Database.select(DatabaseSeason.self)
            {
                for season in seasons
                {
                    var insertPlayers: [DatabasePlayer] = []
                    var insertSkaterStats: [DatabaseSkaterStats] = []
                    var insertGoalieStats: [DatabaseGoalieStats] = []
                    if let seasonId = season.id,
                       let games = Database.select(DatabaseGame.self, where: Where(DatabaseGame.self, .seasonId, ==, seasonId))
                    {
                        for game in games
                        {
                            if let gameId = game.id
                            {
                                logger.info("Fetching player stats for game with ID: \(gameId)")
                                if let webPlayerStats = WebRequest.getData(WebPlayerStats(forGame: gameId)),
                                   let homeTeamId = webPlayerStats.teams?.home?.team?.id,
                                   let awayTeamId = webPlayerStats.teams?.away?.team?.id,
                                   let homePlayers = webPlayerStats.teams?.home?.players,
                                   let awayPlayers = webPlayerStats.teams?.away?.players
                                {
                                    for homePlayer in homePlayers.values
                                    {
                                        if let homePerson = homePlayer.person,
                                           let homePersonId = homePerson.id
                                        {
                                            if !playerIds.contains(homePersonId)
                                            {
                                                insertPlayers.append(DatabasePlayer(from: homePerson))
                                                playerIds.append(homePersonId)
                                            }
                                            
                                            if let homeSkaterStats = homePlayer.stats?.skaterStats
                                            {
                                                insertSkaterStats.append(DatabaseSkaterStats(from: homeSkaterStats,
                                                                                             usingGameId: gameId,
                                                                                             usingTeamId: homeTeamId,
                                                                                             usingPlayerId: homePersonId))
                                            }
                                            
                                            if let homeGoalieStats = homePlayer.stats?.goalieStats
                                            {
                                                insertGoalieStats.append(DatabaseGoalieStats(from: homeGoalieStats,
                                                                                             usingGameId: gameId,
                                                                                             usingTeamId: homeTeamId,
                                                                                             usingPlayerId: homePersonId))
                                            }
                                        }
                                    }
                                    
                                    for awayPlayer in awayPlayers.values
                                    {
                                        if let awayPerson = awayPlayer.person,
                                           let awayPersonId = awayPerson.id
                                        {
                                            if !playerIds.contains(awayPersonId)
                                            {
                                                insertPlayers.append(DatabasePlayer(from: awayPerson))
                                                playerIds.append(awayPersonId)
                                            }
                                            
                                            if let awaySkaterStats = awayPlayer.stats?.skaterStats
                                            {
                                                insertSkaterStats.append(DatabaseSkaterStats(from: awaySkaterStats,
                                                                                             usingGameId: gameId,
                                                                                             usingTeamId: awayTeamId,
                                                                                             usingPlayerId: awayPersonId))
                                            }
                                            
                                            if let awayGoalieStats = awayPlayer.stats?.goalieStats
                                            {
                                                insertGoalieStats.append(DatabaseGoalieStats(from: awayGoalieStats,
                                                                                             usingGameId: gameId,
                                                                                             usingTeamId: awayTeamId,
                                                                                             usingPlayerId: awayPersonId))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    var insertTransaction = Transaction()
                    insertTransaction.insert(values: insertPlayers)
                    insertTransaction.insert(values: insertSkaterStats)
                    insertTransaction.insert(values: insertGoalieStats)
                    logger.info("Inserting \(insertPlayers.count) players to database.")
                    logger.info("Inserting \(insertSkaterStats.count) skater stats to database.")
                    logger.info("Inserting \(insertGoalieStats.count) goalie stats to database.")
                    if let inserted = Database.execute(insertTransaction)
                    {
                        logger.info("Inserted \(inserted) players and skater/goalie stats to database.")
                    }
                }
            }
        }

        logger.info("Finished setting up: Players AND Skater Stats AND Goalie Stats")
    }
}
