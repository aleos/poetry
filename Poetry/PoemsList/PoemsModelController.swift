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
        Blogger.sharedInstance.listPosts(blogId: NSBundle.mainBundle().infoDictionary!["BlogId"] as! String) { (postList, error) in
            if let error = error {
                print("Error fetching posts\(error)")
            } else if let postList = postList {
                self.poems = postList.items
                completion(poems: postList.items)
            } else {
                fatalError()
            }
        }
    }
}