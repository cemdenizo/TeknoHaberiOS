//
//  ArticleViewController.swift
//  NewsApp
//
//  Created by Deniz Onalp on 1.04.2022.
//

import UIKit

class ArticleViewController: UIViewController {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var authourLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var article:Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headlineLabel.text = article?.title?.uppercased()
        authourLabel.text = article?.author
        contentLabel.text = article?.content
        
        fetchImage(urlString: (article?.urlToImage)!) { image in
            self.newsImageView.image = image
        }
        
    }
    
   private func fetchImage(urlString: String, completed: @escaping (_ image: UIImage) -> ())
    {
        let url = URL(string: urlString)
        
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil && data != nil {
                if let imageData = data {
                    let image = UIImage(data: imageData)!
                
                    DispatchQueue.main.async {
                        completed(image)
                    }
                }
            }
        }
        dataTask.resume()
    }
}
