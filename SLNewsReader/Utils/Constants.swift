//
//  Constants.swift
//  SLNewsReader
//
//  Created by SAKSHI TIWARI on 01/09/18.
//  Copyright © 2018 SAKSHI TIWARI. All rights reserved.
//

import Foundation
import UIKit
let baseURLString = "https://newsapi.org/v2/"
let apiKey = "92bd2d430c524e5aba4d8f4b7d772fad"

let TOP_HEADLINES =  baseURLString  + "top-headlines?country=us&category=business&apiKey=92bd2d430c524e5aba4d8f4b7d772fad"
let EVERYTHING_BY_PUBLISHED_AT =  baseURLString  + "everything?q=bitcoin&sortBy=publishedAt&apiKey=92bd2d430c524e5aba4d8f4b7d772fad"
let EVERYTHING_BY_POPULARITY =  baseURLString  + "everything?q=apple&from=2018-08-30&to=2018-08-30&sortBy=popularity&apiKey=92bd2d430c524e5aba4d8f4b7d772fad"
let EVERYTHING_DOMAIN =  baseURLString  + "everything?domains=wsj.com&apiKey=92bd2d430c524e5aba4d8f4b7d772fad"

