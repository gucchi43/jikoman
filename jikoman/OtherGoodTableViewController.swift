/*
 * "Hello Swift, Goodbye Obj-C."
 * Converted by 'objc2swift'
 *
 * https://github.com/yahoojapan/objc2swift
 */

class OtherGoodTableViewController: UITableViewController {
    @IBOutlet private var otherTableView: UITableView!
    private var items: [AnyObject] {
    private   if !_items {
    private     _items = [].mutableCopy
    private }
    private return _items
    private }
    
    @IBAction func unwindtoSubmit(segue: UIStoryboardSegue) {
        print("OtherGoodTableView retun action")
    }
    
    func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.addTarget(self, action: "updateCells", forControlEvents: UIControlEventValueChanged)
        self.loadItems()
    }
    
    func loadItems() {
        var query = PFQuery.queryWithClassName("Ichizen")
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject], error: NSError) in
            objects.enumerateObjectsUsingBlock({ (obj: PFObject, idx: UInt, stop: Bool) in self.items.addObject(obj) })
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func updateCells() {
        print("引張リング")
    }
    
    func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        var ichizen = self.items[indexPath.row]
        var label2 = cell.viewWithTag(2)
        label2.text = ichizen["text"]
        var imgView = cell.viewWithTag(3) as! UIImageView
        var imageFile = ichizen["Img1"]
        if imageFile {
            imageFile.getDataInBackgroundWithBlock({ (data: NSData, error: NSError) in
                if !error {
                    imgView.image = UIImage.imageWithData(data)
                } else {
                    print("\(error)")
                    imgView.image = nil
                    imgView.backgroundColor = UIColor.darkGrayColor()
                }
            })
        } else {
            imgView.image = nil
            imgView.backgroundColor = UIColor.darkGrayColor()
        }
        return cell
    }
}

private extension OtherGoodTableViewController: UITableViewDataSource, UITableViewDelegate {
}
