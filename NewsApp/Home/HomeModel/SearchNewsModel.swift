//
//  SearchNewsModel.swift
//  NewsApp
//
//  Created by Nihad Ismayilov on 30.03.22.
//

import Foundation

struct SearchNewsModel: Decodable {
    let articles: [SearchData]?
}

struct SearchData: Decodable {
    let title: String?
    let author: String?
    let published_date: String?
    let link: String?
    let excerpt: String?
    let summary: String?
    let topic: String?
    let media: String?
    let twitter_account: String?
}
