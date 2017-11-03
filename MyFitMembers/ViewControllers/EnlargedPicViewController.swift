//
//  EnlargedPicViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 19/11/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class EnlargedPicViewController: UIViewController {
    
    //MARK::- OUTLETS
    
    
    @IBOutlet weak var constraintWidthImage: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightImage: NSLayoutConstraint!
    @IBOutlet weak var imageProduct: UIImageView!
    
    //MARK::- VARIABLES
    var imageProd: String?
    var fromSelfie: Bool?
    var selfieImage:UIImage?
    
    //MARK::- OVERRIDE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateImage()
    }
    
    
    
    //MARK::- FUNCTION
    
    func updateImage(){
        guard let fromSelfie = fromSelfie else {return}
        if fromSelfie{
            imageProduct.image = selfieImage
        }else{
            guard let imageUrlX = URL(string: imageProd ?? "") else {return}
            
            imageProduct.yy_setImage(with: imageUrlX, placeholder: UIImage(named: "placeholder_food_big"), options: .progressiveBlur) { (image, url, imgFromType, imgStg, error) in
                let height = image?.size.height ?? 100
                let width = image?.size.width ?? 100
                let heightToSet = (DeviceDimensions.width * height)/width
                if width > DeviceDimensions.width{
                    
                    self.constraintWidthImage.constant = DeviceDimensions.width
                    self.constraintHeightImage.constant = heightToSet ?? DeviceDimensions.width
                }else{
                    self.constraintWidthImage.constant = width
                    self.constraintHeightImage.constant = heightToSet ?? DeviceDimensions.width
                }
            }

        }
    }
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        fromEnlargedScreen = true
        popVC()
    }
    
}
