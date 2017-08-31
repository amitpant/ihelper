//
//  GradientView.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 04/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//


import UIKit

class GradientView: UIView {
    
    lazy fileprivate var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        //layer.colors = [UIColor.clear.cgColor, UIColor(white: 0.0, alpha: 0.75).cgColor]
        layer.colors = [ CommonHelper.mainColor.cgColor, UIColor.clear.cgColor]
        layer.locations = [NSNumber(value: 0.0 as Float), NSNumber(value: 1.0 as Float)]
        return layer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = 4.0
    }
    
}
