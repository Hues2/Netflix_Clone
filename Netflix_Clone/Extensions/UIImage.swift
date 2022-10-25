//
//  UIImage.swift
//  Netflix_Clone
//
//  Created by Greg Ross on 25/10/2022.
//

import Foundation
import UIKit


extension UIImage{
    func changeSize(_ size: CGSize) -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
