//
//  String.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 25/10/2022.
//

import Foundation


extension String{
    func capitalizeFirstLetter() -> String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
