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
