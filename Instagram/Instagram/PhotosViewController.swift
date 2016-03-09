//
//  PhotosViewController.swift
//  Instagram
//
//  Created by nguyen trung quang on 3/9/16.
//  Copyright © 2016 coderSchool. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var photosTableView: UITableView!

    var dataArray:Array<NSDictionary>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photosTableView.dataSource = self
        self.photosTableView.delegate = self

        // Do any additional setup after loading the view.
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
//                            NSLog("response: \(responseDictionary)")
                            print("response: \(responseDictionary)")
                            self.dataArray = responseDictionary["data"] as? [NSDictionary]
                            self.photosTableView.reloadData()
                    }
                }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK tableViewDatasource
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoCell
        let dic = self.dataArray![indexPath.row]
        let image = dic["images"] as! NSDictionary
        let lowResolution = image["low_resolution"] as! NSDictionary
        let urlImage = lowResolution["url"] as! String
        cell.photoImageView.setImageWithURL(NSURL(string: urlImage)!)
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray?.count ?? 0
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 320.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destinationViewController as! PhotoDetailViewController
        let indexPath = self.photosTableView.indexPathForCell(sender as! UITableViewCell)
        
        let dic = self.dataArray![indexPath!.row]
        let image = dic["images"] as! NSDictionary
        let lowResolution = image["standard_resolution"] as! NSDictionary
        let urlImage = lowResolution["url"] as! String
        vc.photoUrl = urlImage
    }

}
