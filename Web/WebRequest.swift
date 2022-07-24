//
//  WebRequest.swift
//  PredictorServer
//
//  Created by Shane Byers on 3/13/22.
//

import Foundation
import OSLog

struct WebRequest
{
    private static let baseUrl = "http://statsapi.web.nhl.com/api/v1/"
    private static let logger = Logger(subsystem: Logger.id, category: Logger.Category.webRequest.rawValue)
    
    public static func getData<T: WebData>(_ webData: T) -> T?
    {
        if let path = webData.path, let url = URL(string: baseUrl + path)
        {
            logger.info("\(url)")
            if let jsonResponse = executeGetRequest(url)
            {
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(T.self, from: jsonResponse)
                {
                    return decodedData
                }
            }
        }
        
        return nil
    }
    
    private static func executeGetRequest(_ url: URL) -> Data?
    {
        var jsonResponse: Data? = nil
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request)
        { data, response, error in
            jsonResponse = data
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return jsonResponse
    }
}
