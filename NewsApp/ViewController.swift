//
//  ViewController.swift
//  NewsApp
//
//  Created by Deniz Onalp on 1.04.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var NewsTableView: UITableView!
    
    var feed = NewsFeed()
    var imgs = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TEKNOHABER"
        
        jsonParse {
            self.NewsTableView.reloadData()
            print(self.feed.totalResults)
        }
        NewsTableView.dataSource = self
        NewsTableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.totalResults
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        
        cell.headlineLabel?.text = feed.articles![indexPath.row].title?.uppercased()
        
        fetchImage(urlString: feed.articles![indexPath.row].urlToImage!) { image in
            cell.newsImageView?.image = image
            self.imgs = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ArticleViewController {
            destination.article = feed.articles![NewsTableView.indexPathForSelectedRow!.row]
        }
    }
    
    //MARK: JSON PARSE FOR NEWS API
    
    private func jsonParse(completed: @escaping () -> ()) {
        let urlString = "https://newsapi.org/v2/top-headlines?category=technology&country=tr&apiKey=f3d1d08d78df4e11a2ff6f651def538e"
        let url = URL(string: urlString)
        
        guard url != nil else {
            return
        }
        let session  = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in

            if error == nil && data != nil {

                let decoder = JSONDecoder()
                do {
                    let newsFeed = try decoder.decode(NewsFeed.self, from: data!)
                    self.feed = newsFeed

                    DispatchQueue.main.async {
                        completed()
                    }
                    
                } catch {
                    print("Error in JSON Parsing")
                }
            }
        }
        dataTask.resume()
    }
    //MARK: IMAGE FETCH AND DISPLAY FROM URL
    private func fetchImage(urlString: String, completed: @escaping (_ image: UIImage) -> ())
    {
        let url = URL(string: urlString)
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil && data != nil {
                if let imageData = data {
                    let image = UIImage(data: imageData)!
    //TODO: CHECK FOR NIL DISPLAY STANDART IMAGE
                    DispatchQueue.main.async {
                        completed(image)
                    }
                }
            }
        }
        dataTask.resume()
    }
}
