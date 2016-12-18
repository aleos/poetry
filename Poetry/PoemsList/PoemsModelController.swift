//
//  PoemsModelController.swift
//  Poetry
//
//  Created by Alexander Ostrovsky on 03.05.16.
//  Copyright © 2016 Alexander Ostrovsky. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

class PoemsModelController {
    fileprivate(set) var poems = [GTLRBlogger_Post]()
    
    func fetchPoems(_ completion: @escaping (_ poems: [GTLRBlogger_Post]) -> ()) {
        Blogger.shared.posts { [weak self] (posts, error) in
            if let error = error {
                print("Error fetching posts\(error)")
            } else {
                self?.poems = posts
                completion(posts)
            }
        }
    }
}
