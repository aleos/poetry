//
//  PoemsViewModel.swift
//  Poetry
//
//  Created by Alexander Ostrovsky on 03.05.16.
//  Copyright © 2016 Alexander Ostrovsky. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST_Blogger

struct Post {
    var title: String
    var text: String
    var date: Date?
    var tags: [String]
}

extension Post {
    var markdownContent: String {
        var content = ""
        for line in text.split(separator: "\n", omittingEmptySubsequences: false) {
            var line = line
            if !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                line = line + "  "
            }
            content += line + "\n"
        }
        content = content.replacingOccurrences(of: "  \n\n", with: "\n\n")
        content = content.replacingOccurrences(of: "*", with: "\\*")
        return content
    }

    var jekyllMarkdown: String {
        """
        ---
        title: "\(title.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\""))"
        date: \(date?.formatted(.iso8601) ?? "")
        tags: \(tags)
        ---
        
        \(markdownContent)
        """
    }
    
    var jekyllFilenameBase: String { "\(date?.formatted(.iso8601.year().month().day()) ?? "")-\(title)" }
    
    init(_ post: GTLRBlogger_Post) {
        title = post.title ?? ""
        text = post.content?.attributedHtmlString?.string ?? ""
        date = post.published.flatMap { ISO8601DateFormatter().date(from: $0) }
        tags = post.labels ?? []
    }
}

class PoemsViewModel: ObservableObject {
    @Published var poems = [Post]()
    
    init() {
        fetchPoems()
    }
    
    private func fetchPoems() {
        Blogger.shared.posts { [weak self] (posts, error) in
            if let error = error {
                print("Error fetching posts\(error)")
            } else {
                self?.poems = posts.map(Post.init)
                #if DEBUG
                self?.savePostsInDocuments(bloggerPosts: posts)
                #endif
            }
        }
    }
    
    private func savePostsInDocuments(bloggerPosts: [GTLRBlogger_Post]) {
        let postsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Posts-\(Date.now.formatted(.iso8601))")
        print("Posts dir URL is \(postsURL)")
        
        do {
            try FileManager.default.createDirectory(at: postsURL, withIntermediateDirectories: true)
        } catch {
            print(error.localizedDescription)
        }
        
        for bloggerPost in bloggerPosts {
            let post = Post(bloggerPost)
            print("================================================")
            print("Title:     \(post.title)")
            print("Published: \(bloggerPost.published ?? "")")
            print("Tags:      \(post.tags)")
            print("Post ID:   \(bloggerPost.identifier ?? "")")
            print("Post URL:  \(bloggerPost.url ?? "")")
            
            do {
                try post.jekyllMarkdown.write(to: postsURL.appendingPathComponent(post.jekyllFilenameBase + ".md"), atomically: true, encoding: .utf8)
            } catch {
                print(error.localizedDescription)
            }
            
            if bloggerPost.images?.isEmpty == false {
                let postImagesFolder = postsURL.appendingPathComponent(post.jekyllFilenameBase)
                do {
                    try FileManager.default.createDirectory(at: postImagesFolder, withIntermediateDirectories: true)
                } catch {
                    print(error.localizedDescription)
                }
                Task {
                    for imageUrlItem in bloggerPost.images ?? [] {
                        guard let url = URL(string: imageUrlItem.url ?? "") else { continue }
                        do {
                            let (imageData, _) = try await URLSession.shared.data(from: url)
                            try imageData.write(to: postImagesFolder.appendingPathComponent(url.lastPathComponent))
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
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
