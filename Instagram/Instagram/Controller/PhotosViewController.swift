//
//  PhotosViewController.swift
//  Instagram
//
//  Created by nguyen trung quang on 3/9/16.
//  Copyright © 2016 HDApps. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //outlet
    @IBOutlet weak var tableView: UITableView!
    
    //property
    var data: [NSDictionary]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchIntasgram()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - tableviewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    // MARK: - requestInstagram
    func  fetchIntasgram(){
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request =  NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.data = responseDictionary.objectForKey("data") as? [NSDictionary]
                              NSLog("response: \(self.data)")
                    }
                }
        });
        // problem
//        let task1 : NSURLSessionDataTask = session.dataTaskWithRequest(request) { (data1, response, error) -> Void in
//            if let data = data1 {
//                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
//                    NSLog("response:\(responseDictionary)")
//                }
//            }
//        }
        
        task.resume()
//        task1.resume()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
