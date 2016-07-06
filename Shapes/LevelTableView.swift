//
//  LevelTableView.swift
//  Shapes
//
//  Created by Chloé Laugier on 27/02/2016.
//  Copyright © 2016 Chloé Laugier. All rights reserved.
//

import Foundation
import UIKit

class LevelTableView : UITableViewController {
    

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        
        //let cellIdentifier = "LevelCellView"
        
        //let cell = LevelCellView()
        //cell.backgroundColor = UIColor.blueColor()
        //tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        return UITableViewCell()
        
    }
    
   
}
