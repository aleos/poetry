//
//  PoemsViewModel.swift
//  Poetry
//
//  Created by Alexander Ostrovsky on 03.05.16.
//  Copyright © 2016 Alexander Ostrovsky. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST_Blogger

struct Poem {
    let title: String
    let text: String
}

class PoemsViewModel: ObservableObject {
    @Published var poems = [Poem]()
    
    init() {
        fetchPoems()
    }
    
    private func fetchPoems() {
        Blogger.shared.posts { [weak self] (posts, error) in
            if let error = error {
                print("Error fetching posts\(error)")
            } else {
                self?.poems = posts.reduce([]) { partialResult, post in
                    guard let title = post.title, let text = post.content?.attributedHtmlString?.string else { return partialResult }
                    return partialResult + [Poem(title: title, text: text)]
                }
            }
        }
    }
    
    private func savePostsInDocuments(posts: [GTLRBlogger_Post]) {
        let postsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Posts-\(Date.now.formatted(.iso8601))")
        print("Posts dir URL is \(postsURL)")
        do {
            try FileManager.default.createDirectory(at: postsURL, withIntermediateDirectories: true)
            for post in posts {
                let publishedDate = ISO8601DateFormatter().date(from: post.published!)!
                let dateFormatted = publishedDate.formatted(.iso8601.year().month().day())
                let postURL = postsURL.appendingPathComponent("\(dateFormatted)-\(post.title!).md")
                try post.content?.attributedHtmlString?.string.write(to: postURL, atomically: true, encoding: .utf8)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension String {
    
    var utfData: Data {
        return Data(utf8)
    }
    
    var attributedHtmlString: NSAttributedString? {
        
        do {
            return try NSAttributedString(data: utfData, options: [
              .documentType: NSAttributedString.DocumentType.html,
              .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil)
        } catch {
            print("Error:", error)
            return nil
        }
    }
}
