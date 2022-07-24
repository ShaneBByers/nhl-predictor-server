//
//  main.swift
//  PredictorServer
//
//  Created by Shane Byers on 12/28/21.
//

import Foundation
import OSLog

let logger = Logger(subsystem: Logger.id, category: Logger.Category.testing.rawValue)

var skaterModel = SkaterModel()
skaterModel.create(seed: 5)
skaterModel.train()
skaterModel.evaluate()
skaterModel.save(inDirectory: ConstantStrings.REGRESSORS_DIRECTORY_PATH.rawValue)

for (column, evaluationMetrics) in skaterModel.evaluationResults
{
    logger.log("Root Mean Square for \(column.rawValue): \(evaluationMetrics.rootMeanSquaredError).")
}
