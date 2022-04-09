//
//  Helper.swift
//  NewsApp
//
//  Created by Nihad Ismayilov on 02.04.22.
//

import Foundation

struct Helper {
    static var sharedInstance = Helper()
    
    var newsIdArray: [String]? = []
    var newsMediaArray: [String]? = []
    var newsTopicArray: [String]? = []
    var newsTitleArray: [String]? = []
    var newsAuthorArray: [String]? = []
    var newsTwitterAccountArray: [String]? = []
    var newsExcerptArray: [String]? = []
    var newsSummaryArray: [String]? = []
    var newsLinkArray: [String]? = []
    var newsDateArray: [String]? = []
    
    private init() {}
}
