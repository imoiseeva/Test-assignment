
//  NetworkManager.swift
//  Test assignment
//
//  Created by Irina Moiseeva on 29.03.2022.


import Foundation
import SwiftSoup

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchInfo() -> String {
        var title = ""
        let urlAddress = "https://news.ycombinator.com/"
        guard let myURL = URL(string: urlAddress) else { return "" }
        
        let html = try! String(contentsOf: myURL, encoding: .utf8)
        
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(html)
            let headerTitle = try doc.title()
            
            // my body
            let body = doc.body()
            // elements to remove, in this case images
            let undesiredElements: Elements? = try body?.select("img[src]")
            //remove
            try undesiredElements?.remove()
            title = headerTitle
            
            print("Header title: \(headerTitle)")
        } catch let error {
            print("Message: \(error)")
        } catch {
            print("error")
        }
        return title
    }
    
}
