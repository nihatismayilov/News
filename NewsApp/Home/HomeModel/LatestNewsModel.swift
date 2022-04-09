//
//  LatestNewsModel.swift
//  NewsApp
//
//  Created by Nihad Ismayilov on 30.03.22.
//

import Foundation

struct LatestNewsModel: Decodable {
    let articles: [NewsData]?
}

struct NewsData: Decodable {
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
