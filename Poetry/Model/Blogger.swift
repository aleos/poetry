//
//  Blogger.swift
//  Poetry
//
//  Created by Alexander Ostrovsky on 18.12.16.
//  Copyright © 2016 Alexander Ostrovsky. All rights reserved.
//

import Foundation

import GoogleAPIClientForREST

class Blogger {
    static let shared = Blogger()
    
    private static let blogId = Bundle.main.infoDictionary!["BlogId"] as! String
    
    let bloggerService: GTLRBloggerService = {
        let service = GTLRBloggerService()
        if let apiKey = Bundle.main.infoDictionary?["BloggerApiKey"] as? String {
            service.apiKey = apiKey
        }
        return service
    }()
    
    private init() {
    }
    
    func posts(completion: @escaping (_ poems: [GTLRBlogger_Post], _ error: Error?) -> Void) {
        let postsQuery = GTLRBloggerQuery_PostsList.query(withBlogId: type(of: self).blogId)
        let _ = bloggerService.executeQuery(postsQuery) { (ticket, object, error) in
            if let error = error {
                completion([], error)
            } else {
                let postsObject = object as! GTLRBlogger_PostList
                completion(postsObject.items ?? [], nil)
            }
        }
    }
}
