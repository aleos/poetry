//
//  RssParser.swift
//  Poetry
//
//  Created by Alexander Ostrovsky on 02.05.16.
//  Copyright © 2016 Alexander Ostrovsky. All rights reserved.
//

import Foundation

protocol AtomParserDelegate: AnyObject {
    func parserDelegateParsingDidFinish(_ parser: AtomParser)
}

struct Entry {
    let published: String
    let updated: String?
    let category: String?
    let title: String
    let content: String
    let link: String?
}

/// Parser of atom feeds from amabilisa.ru (blogger)
///
/// Usage:
///
///     let parser = AtomParser()
///     if let url = NSURL(string: "http://amabilisa.ru/feeds/posts/default") {
///         parser.startParsingWithContentsOfURL(url)
///     }
class AtomParser: NSObject {
    fileprivate enum EntryKey: String {
        case Published = "published"
        case Updated = "updated"
        case Category = "category"
        case Title = "title"
        case Content = "content"
        case Link = "link"
        case Author = "author"
    }
    
    weak var delegate: AtomParserDelegate?
    
    fileprivate var arrParsedData = [[EntryKey: String]]()
    fileprivate var currentDataDictionary = [EntryKey: String]()
    
    fileprivate var currentElement: EntryKey?
    fileprivate var foundCharacters = ""
    
    func startParsingWithContentsOfURL(_ rssURL: URL) {
        if let parser = XMLParser(contentsOf: rssURL) {
            parser.delegate = self
            parser.parse()
        }
    }
}

extension AtomParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = EntryKey(rawValue: elementName)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let _ = currentElement {
            foundCharacters += string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if let currentElement = currentElement {
            currentDataDictionary[currentElement] = foundCharacters
            
            foundCharacters = ""
            
            if case EntryKey.Content = currentElement {
                arrParsedData.append(currentDataDictionary)
                if let published = currentDataDictionary[.Published],
                    let title = currentDataDictionary[.Title]?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil),
                    let content = currentDataDictionary[.Content] {
                    _ = Entry(published: published, updated: currentDataDictionary[.Updated], category: currentDataDictionary[.Category], title: title, content: content, link: currentDataDictionary[.Link])
                    
                    print(currentDataDictionary)
                }
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        delegate?.parserDelegateParsingDidFinish(self)
    }
}
