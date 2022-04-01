
//  NetworkManager.swift
//  Test assignment
//
//  Created by Irina Moiseeva on 29.03.2022.


import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchInfo() -> String {
        guard let myURL = URL(string: "http://whatismyip.akamai.com") else { return "" }
        let html = try! String(contentsOf: myURL, encoding: .utf8)
        return html
    }
}
