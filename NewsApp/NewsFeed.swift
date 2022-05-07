//
//  NewsFeed.swift
//  NewsApp
//
//  Created by Deniz Onalp on 1.04.2022.
//
import Foundation

struct NewsFeed: Codable {
    
    var status:String = ""
    var totalResults:Int = 0
    var articles:[Article]?
    
}
