//
//  ClientInfoStepTwoViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/29/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit
import Fusuma

class ClientInfoStepTwoViewController: UIViewController {
    //MARK::- OUTLETS
    
    @IBOutlet weak var btnCamera: UIButton!{
        didSet{
            btnCamera.layer.cornerRadius = btnCamera.frame.height/2
        }
    }
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var imageProfile: UIImageView!{
        didSet{
            imageProfile.layer.cornerRadius = imageProfile.frame.height/2
        }
    }
    //MARK::- VARIABLES
    
    var clientInfoStepThreeVc:ClientInfoThreeViewController?
    var showSkip = true
    
    //MARK::- OVVERIDE FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateViewControllers()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpSideBar(false,allowRighSwipe: false)
        if showSkip{
            showSkip = false
            btnNext.setTitle("SKIP", for: UIControlState())
        }else{
            showSkip = false
        }
        let imageSelectCheck = UserDefaults.standard.value(forKey: "ImageSelected") as? Bool ?? false
        
        if imageSelectCheck{
            btnNext.setTitle("NEXT", for: UIControlState())
        }else{
            btnNext.setTitle("SKIP", for: UIControlState())
        }
        tapOnCamera()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK::- FUNCTIONS
    
    func instantiateViewControllers(){
    }
    
    func tapOnCamera(){
        imageProfile.addTapGesture { (tap) in
            self.btnNext.setTitle("NEXT", for: UIControlState())
            let alertcontroller =   UIAlertController.showActionSheetController(title: "Choose your action", buttons: ["Camera" , "Photo Library"], success: { [unowned self]
                (state) -> () in
                self.callFusumaImagePicker(state)
                })
            self.present(alertcontroller, animated: true, completion: nil)
        }
    }
    
    func callFusumaImagePicker(_ item:String){
        allowRev = false
        CameraGalleryPickerBlock.sharedInstance.pickerImage(type: item, presentInVc: self, pickedListner: {
            [unowned self]
            (image,imageUrl) -> () in
            self.imageProfile.image = image
            UserDefaults.standard.setValue(true, forKey: "ImageSelected")
            }, canceledListner: { [weak self] in
                
            } , allowEditting:true)
        
    }
    
    //MARK::- DELEGATE
    
    
    //MARK::- ACTIONS
    
    @IBAction func btnActionCamera(_ sender: UIButton) {
        
    }
    
    @IBAction func btnActionNext(_ sender: UIButton) {
        sendUserInformation()
    }
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
    
}


extension ClientInfoStepTwoViewController{
    
    //MARK::- API
    
    func sendUserInformation(){
        guard let dictForBackEnd = UserDefaults.standard.rm_customObject(forKey: "AddNewUserInformation") as?  OptionalDictionary else {return}
        UserDefaults.standard.rm_setCustomObject(dictForBackEnd, forKey: "AddNewUserInformationWithImage")
        
        print(dictForBackEnd)
        ApiDetector.getDataOfURL(ApiCollection.apiAddClient, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                print(data)
                self?.showSkip = true
                guard let clientData = data as? ClientAddedDetail else {return}
                let vc = StoryboardScene.Main.instantiateClientInfoThreeViewController()
                vc.clientId = clientData.clientId
                self?.pushVC(vc)
                self?.btnBack.isEnabled = false
                UserDefaults.standard.setValue(nil, forKey: "ImageSelected")
            }, method: .postWithImage, viewControl: self, pic: imageProfile?.image , placeHolderImageName: "profilePic", headers: [:] , showLoader: true, loaderColor: Colorss.darkRed.toHex())
    }
    
    
    
    
}

extension ClientInfoStepTwoViewController : FusumaDelegate{
    
    //MARK::- Fusuma delegates
    
    func fusumaImageSelected(_ image: UIImage) {
        imageProfile.image = image
        let img = cropToBounds(image, width: 400, height: 400)
        UserDefaults.standard.setValue(true, forKey: "ImageSelected")
        btnCamera.setImage(img, for: UIControlState())
        btnCamera.setImage(img, for: .highlighted)
        btnCamera.setImage(img, for: .selected)
        print("Image selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(_ image: UIImage) {
        print("Called just after FusumaViewController is dismissed.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        print("Camera roll unauthorized")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
    }
    
    
    
    func cropToBounds(_ image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = (contextImage.cgImage)!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
}
