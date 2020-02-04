//
//  Colors.swift
//  todo
//
//  Created by Alejandro Mendoza on 03/02/20.
//  Copyright © 2020 Alejandro Mendoza. All rights reserved.
//

import UIKit

func getColorFrom(_ tagBackgroundColor: TagBackgroundColors) -> UIColor {
    return UIColor(named: tagBackgroundColor.rawValue) ?? UIColor.systemPink
}
