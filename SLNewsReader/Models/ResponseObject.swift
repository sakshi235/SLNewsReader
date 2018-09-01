/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import UIKit
let BLANK = " "
struct Source {
    var id: String
    var name: String
    init?(dictionary: [String: String]) {
        guard let id = dictionary["id"],
            let name = dictionary["name"] else{
                self.id = BLANK
                self.name = BLANK
                return
        }
        self.id  = id
        self.name = name
    }
}

struct ResponseObject {
  var urlToImage: String
  var publishedAt: String
  var title: String
  var description: String
  var author: String
  var url: String
  var source: Source
    
    init?() {
     self.init(urlToImg: BLANK, publishAt: BLANK, title: BLANK, description: BLANK, author: BLANK, url: BLANK, sourceData: Source.init(dictionary: [:])!)
     return
    }
    
    init?(dictionary: NSDictionary) {
    guard let urlToImage = dictionary["urlToImage"],
          let publishedAt = dictionary["publishedAt"],
          let title = dictionary["title"],
          let description = dictionary["description"],
          let author = dictionary["author"],
          let url = dictionary["url"],
        let source = Source.init(dictionary: dictionary["source"] as? [String: String] ?? [:]) else{
            self.init(urlToImg: BLANK, publishAt: BLANK, title: BLANK, description: BLANK, author: BLANK, url: BLANK, sourceData: Source.init(dictionary: [:])!)
            return
    }
    self.init(urlToImg: urlToImage, publishAt: publishedAt, title: title, description: description, author: author, url: url, sourceData: source)
    
  }
    init(urlToImg:Any,publishAt:Any,title:Any,description:Any,author:Any,url:Any,sourceData:Source) {
        self.urlToImage = urlToImg as? String ?? " "
        self.publishedAt = publishAt as? String ?? " "
        self.title = title as? String ?? " "
        self.description = description as? String ?? " "
        self.author = author as? String ?? " "
        self.url = url as? String ?? " "
        self.source = sourceData
    }
}
