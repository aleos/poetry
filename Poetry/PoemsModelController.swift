//
//  PoemsModelController.swift
//  Poetry
//
//  Created by Alexander Ostrovsky on 03.05.16.
//  Copyright © 2016 Alexander Ostrovsky. All rights reserved.
//

import Foundation
import GoogleAPIs

class PoemsModelController {
    private(set) var poems = [BloggerPost]()
    
    private func configureBlogger() {
        Blogger.sharedInstance.fetchBodies = false
    }
    
    func fetchPoems(completion: (poems: [BloggerPost]) -> ()) {
        Blogger.sharedInstance.listPosts(blogId: "7661037823808726647") { (postList, error) in
            if let error = error {
                print("Error fetching posts\(error)")
            } else if let postList = postList {
                for post in postList.items {
                    print("\(post.title)\n\(post.content)\n")
                }
                completion(poems: postList.items)
            } else {
                fatalError()
            }
        }
    }
}