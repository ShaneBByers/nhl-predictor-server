//
//  DatabaseLogin.swift
//  PredictorServer
//
//  Created by Shane Byers on 7/3/22.
//

import Foundation

struct DatabaseLogin : Encodable
{
    let serverName = ConstantStrings.DB_SERVER_NAME.rawValue
    let username = ConstantStrings.DB_USERNAME.rawValue
    let password = ConstantStrings.DB_PASSWORD.rawValue
    let databaseName = ConstantStrings.DB_DATABASE_NAME.rawValue
}
