//
//  ViewController.swift
//  SuperHeroPedia
//
//  Created by Jonathan Kilgore on 2/1/16.
//  Copyright © 2016 Jonathan Kilgore. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var heroes = [NSDictionary]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //https://s3.amazonaws.com/mmios8week/superheroes.json
        
        let url = NSURL(string: "https://s3.amazonaws.com/mmios8week/superheroes.json")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data, response, error) -> Void in
            do {
                self.heroes = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [[String : String]]
            } catch let error as NSError {
                print("jsonError: \(error.localizedDescription)")
            }
            self.tableView.reloadData()
        }
            task.resume()
        
//        let batmanDictionary = ["name": "Batman", "identity": "Bruce Wayne"]
//        let greenLanternDictionary = ["name": "Green Lantern", "identity": "Hal Jordan"]
//        
//        heroes = [batmanDictionary, greenLanternDictionary]
    
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID")!
        
        cell.textLabel?.text = heroes[indexPath.row]["name"] as? String
        cell.detailTextLabel?.text = heroes[indexPath.row]["description"] as? String
        
        let url = NSURL(string: (heroes[indexPath.row]["avatar_url"] as? String)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cell.imageView?.image = UIImage(data: data!)
                cell.layoutSubviews()
                })
        }
        task.resume()
        
        return cell
    }

}

