//
//  HomeVM.swift
//  NewsApp
//
//  Created by Nihad Ismayilov on 30.03.22.
//

import Foundation

struct LatestNewsViewModel {
    
    func showLatestNews(_LatestLanguage: String, completion: @escaping (LatestNewsModel?) -> ()) {
        
        let string = "https://api.newscatcherapi.com/v2/latest_headlines?lang=\(_LatestLanguage)&countries=US&page_size=5"
        
        let url = URL(string: string)
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("6_rfZ5tO1OJwzeBhPXXzBHaIk19c1VbelA6mrshdeMs", forHTTPHeaderField: "x-api-key")
        request.httpMethod = "GET"
        let session = URLSession.shared

        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let data = data {
                    do {
                        let decode = try JSONDecoder().decode(LatestNewsModel.self, from: data)
                        print(decode)
                        completion(decode)
                    } catch{
                        print(error.localizedDescription)
                    }
            }
        
            }
        }
        task.resume()
    }

}

struct SearchViewModel {
    
    func searchForNews(_ SearchText: String, SearchLanguage: String, completion: @escaping (SearchNewsModel?) -> ()) {
        
        let text = SearchText.replacingOccurrences(of: " ", with: "%20")
        
        let string = "https://api.newscatcherapi.com/v2/search?lang=\(SearchLanguage)&countries=US&q=\(text)"
        
        guard let url = URL(string: string) else { return }
        let request = NSMutableURLRequest(url: url as URL)
        request.setValue("6_rfZ5tO1OJwzeBhPXXzBHaIk19c1VbelA6mrshdeMs", forHTTPHeaderField: "x-api-key")
        request.httpMethod = "GET"
        let session = URLSession.shared

        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let data = data {
                    do {
                        let decode = try JSONDecoder().decode(SearchNewsModel.self, from: data)
                        print(decode)
                        completion(decode)
                    } catch{
                        print(error.localizedDescription)
                    }
            }
        
            }
        }
        task.resume()
    }
}


