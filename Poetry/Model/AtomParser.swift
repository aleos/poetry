//
//  RssParser.swift
//  Poetry
//
//  Created by Alexander Ostrovsky on 02.05.16.
//  Copyright © 2016 Alexander Ostrovsky. All rights reserved.
//

import Foundation

protocol AtomParserDelegate: class {
    func parserDelegateParsingDidFinish(parser: AtomParser)
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
    private enum EntryKey: String {
        case Published = "published"
        case Updated = "updated"
        case Category = "category"
        case Title = "title"
        case Content = "content"
        case Link = "link"
        case Author = "author"
    }
    
    weak var delegate: AtomParserDelegate?
    
    private var arrParsedData = [[EntryKey: String]]()
    private var currentDataDictionary = [EntryKey: String]()
    
    private var currentElement: EntryKey?
    private var foundCharacters = ""
    
    func startParsingWithContentsOfURL(rssURL: NSURL) {
        if let parser = NSXMLParser(contentsOfURL: rssURL) {
            parser.delegate = self
            parser.parse()
        }
    }
}

extension AtomParser: NSXMLParserDelegate {
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement = EntryKey(rawValue: elementName)
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if let _ = currentElement {
            foundCharacters += string
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if let currentElement = currentElement {
            currentDataDictionary[currentElement] = foundCharacters
            
            foundCharacters = ""
            
            if case EntryKey.Content = currentElement {
                arrParsedData.append(currentDataDictionary)
                if let published = currentDataDictionary[.Published],
                    title = currentDataDictionary[.Title]?.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil),
                    content = currentDataDictionary[.Content] {
                    let entry = Entry(published: published, updated: currentDataDictionary[.Updated], category: currentDataDictionary[.Category], title: title, content: content, link: currentDataDictionary[.Link])
                    
                    print(currentDataDictionary)
                }
            }
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        delegate?.parserDelegateParsingDidFinish(self)
    }
}