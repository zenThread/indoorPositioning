//
//  setupTableViewController.swift
//  indoorPositioning
//
//  Created by isaiah childs on 8/15/20.
//  Copyright © 2020 isaiah childs. All rights reserved.
//

import UIKit

class setupTableViewController: UITableViewController,changedelegate {
    var delegate : rootchange!
    var x:NSDictionary!
  
    func editVal(delta: Float,name:String) {
        
    
        
        delegate.editdelegate(nam: name, xdelta: delta)
     
      
    }
  
    
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print(x.count)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    @IBAction func back(_ sender:Any){
        dismiss(animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        
        return x.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> editData {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editdata", for: indexPath) as! editData
        let k = x.allKeys as! [String]
        let val = x.allValues
        cell.editname.text = "\(k[indexPath.row])"
        cell.editlabel.placeholder = "\(val[indexPath.row])"
        cell.delegate = self
        
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
class editData:UITableViewCell{
    @IBOutlet weak var editname:UILabel!
    @IBOutlet weak var editlabel:UITextField!
    var delegate:changedelegate!
    
    @IBAction func change(_ sender: Any) {
        let y = editlabel.text!
        let r = Float(y)
        
        delegate.editVal(delta: r!,name: editname.text!)
    }
    
}

protocol changedelegate {
    func editVal(delta:Float,name:String)
}
class dataset{
    var nx:Float = 0
    var ny:Float = 0
    var Beacon2Degree = 0
}
