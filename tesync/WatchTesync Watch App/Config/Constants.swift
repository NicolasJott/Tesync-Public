//
//  Constants.swift
//  tesync
//
//  Created by Nicolas Ott on 10/14/24.
//

import Foundation

struct Constants {
    
    // Tesla Constants
    static let clientID: String = {
        return Bundle.main.object(forInfoDictionaryKey: "TESLA_CLIENT_ID") as? String ?? ""
    }()

    static let clientSecret: String = {
        return Bundle.main.object(forInfoDictionaryKey: "TESLA_CLIENT_SECRET") as? String ?? ""
    }()

    static let redirectURI: String = {
        return "https://\(Bundle.main.object(forInfoDictionaryKey: "TESLA_REDIRECT_URL") ?? "")"
    }()
    static let teslaDomain: String = {
        return Bundle.main.object(forInfoDictionaryKey: "TESLA_DOMAIN") as? String ?? ""
    }()
    
    // API URL
    static let apiURL: String = {
        return "http://\(Bundle.main.object(forInfoDictionaryKey: "API_URL" ) ?? "")"
    }()
}
