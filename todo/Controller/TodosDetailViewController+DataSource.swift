//
//  TodosDetailViewController+DataSource.swift
//  todo
//
//  Created by Alejandro Mendoza on 14/01/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

extension TodosDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.DetailTodoCellIdentifier, for: indexPath)
        guard let todoCell = cell as? TodoTableViewCell else { return cell }
        
        
        let testTag = "#Something"
        
        if let location = getLocationOfTagFrom(testTag, beginningWith: Constants.TagIdentifier), let tagBackgroundIdentifier = TagBackgroundColors.allCases.randomElement(), let color = UIColor(named: tagBackgroundIdentifier.rawValue) {
            
            let highlightedTag = getHighlightedTextFor(testTag, withLocation: location, color: color, wide: true)
            
            todoCell.todoTag = highlightedTag
        }
        
        return cell
    }
    
    
}
