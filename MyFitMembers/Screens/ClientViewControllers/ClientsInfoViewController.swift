//
//  ClientInfoViewController.swift
//  MyFitMembers
//
//  Created by Boris Esanu on 9/27/16.
//  Copyright © 2016 Codebrew. All rights reserved.
//

import UIKit

class ClientsInfoViewController: UIViewController ,UIPageViewControllerDataSource ,UIPageViewControllerDelegate , DateOfBirthClicked , SetDate{
    
    
    //MARK::- Outlets
    
    @IBOutlet weak var labelUserName: UITextField!{
        didSet{
            labelUserName.text = UserDataSingleton.sharedInstance.loggedInUser?.name
        }
    }
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imageUser: UIImageView!{
        didSet{
            imageUser.layer.cornerRadius = imageUser.frame.height/2
        }
    }
    @IBOutlet weak var viewContentView: UIView!
    @IBOutlet weak var btnPersonalInfo: UIButton!
    @IBOutlet weak var btnFitnessInfo: UIButton!
    @IBOutlet weak var viewFloatingFitnessInfo: UIView!
    @IBOutlet weak var viewFloatingPersonalInfo: UIView!
    
    //MARK::- Variables
    var clientPersonalInfo: ClientPersonalInfoViewController?
    var clientSettings: ClientSettingsViewController?
    var trainerProfileVc: TrainerProfileViewController?
    var trainerSettingsVc: TrainerSettingsViewController?
    
    var viewControllerArray:NSArray? = []
    var pageController : UIPageViewController?
    var blackColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.88)
    var greyColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.44)
    var edit = true
    var dateChooserView: DateChooser?
    var boolBlockApi = false
    //MARK::- Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewFloatingFitnessInfo.isHidden = true
        instantiateViewControllers()
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
        if isClient{
            guard let clientPersonalInfo = clientPersonalInfo else {return}
            setUp(clientPersonalInfo)
        }else{
            guard let trainerProfileVc = trainerProfileVc else {return}
            setUp(trainerProfileVc)
        }
        imageUser.layer.cornerRadius = imageUser.frame.height/2
        setUpSideBar(false,allowRighSwipe: false)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if boolBlockApi{
            boolBlockApi = false
            
        }else{
            boolBlockApi = false
            getPersonalDetails(false)
        }
        
        if edit{
            btnEdit.setImage(UIImage(named: "ic_edit_white"), for: UIControlState())
            btnEdit.setTitle("", for: UIControlState())
            
        }else{
            btnEdit.setTitle("SAVE", for: UIControlState())
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK::- DELEGATE
    
    func showDatePicker(){
        view.endEditing(true)
        showAnimate(dateChooserView ?? UIView() )
        self.view.addSubview(dateChooserView ?? UIView())
    }
    
    func setDate(_ date:String){
        guard let vc = clientPersonalInfo else {return}
        guard let cell = vc.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ClientPersonalInfoTableViewCell else {return}
        cell.labelAge.text = date
    }
    
    //MARK::- Functions
    func instantiateViewControllers(){
        clientPersonalInfo = StoryboardScene.ClientStoryboard.instantiateClientPersonalInfoViewController()
        clientPersonalInfo?.delegate = self
        clientSettings = StoryboardScene.ClientStoryboard.instantiateClientSettingsViewController()
        trainerProfileVc = StoryboardScene.Main.instantiateTrainerProfileViewController()
        trainerSettingsVc = StoryboardScene.Main.instantiateTrainerSettingsViewController()
        dateChooserView = DateChooser(frame: CGRect(x: 0, y: 0, width: DeviceDimensions.width, height: DeviceDimensions.height))
        dateChooserView?.delegate = self
    }
    
    func upadteData(){
        imageUser.layer.cornerRadius = imageUser.frame.height/2
        let imgUrl = UserDataSingleton.sharedInstance.loggedInUser?.userImage?.userOriginalImage
        let imageUrl = URL(string: ApiCollection.apiImageBaseUrl + (imgUrl ?? ""))
        imageUser.yy_setImage(with: imageUrl, placeholder: UIImage(named: "ic_placeholder"))
        labelUserName.text = UserDataSingleton.sharedInstance.loggedInUser?.name?.uppercaseFirst
    }
    
    func setUp(_ firstViewControl: UIViewController){
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
        if isClient{
            guard let clientPersonalInfo = clientPersonalInfo , let clientSettings = clientSettings else {return}
            viewControllerArray = [clientPersonalInfo,clientSettings]
        }else{
            guard let trainerProfileVc = trainerProfileVc , let trainerSettingsVc = trainerSettingsVc else {return}
            viewControllerArray = [trainerProfileVc, trainerSettingsVc]
        }
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageController?.setViewControllers([firstViewControl], direction: .forward, animated: true, completion: nil)
        pageController?.view.frame = CGRect(x: 0, y: 0, width: viewContentView.bounds.width, height: viewContentView.bounds.height)
        pageController?.delegate = self
        pageController?.dataSource = self
        guard let pageController = pageController else{return}
        self.addChildViewController(pageController)
        self.viewContentView.addSubview(pageController.view)
        self.pageController?.didMove(toParentViewController: self)
    }
    
    func setViewController(_ vc:UIViewController, sender:UIButton){
        if(sender.tag == 0){
            self.pageController?.setViewControllers([vc], direction: .reverse, animated: true, completion: nil)
        }else{
            self.pageController?.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        }
    }
    
    //MARK::- PAGEVIEWCONTROLLER DELEGATE
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return UIViewController() }
        if isClient{
            if viewController .isKind(of: ClientPersonalInfoViewController.self) {
                return clientSettings
            }else{
                return nil
            }
        }else{
            if viewController .isKind(of: TrainerProfileViewController.self) {
                return trainerSettingsVc
            }else{
                return nil
            }
        }
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return UIViewController() }
        if isClient{
            if viewController .isKind(of: ClientSettingsViewController.self) {
                return clientPersonalInfo
            }else{
                return nil
            }
            
        }else{
            if viewController .isKind(of: TrainerSettingsViewController.self) {
                return trainerProfileVc
            }else{
                return nil
            }
            
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        if completed{
            guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return }
            
            if isClient{
                if previousViewControllers.first is ClientPersonalInfoViewController{
                    viewFloatingPersonalInfo.isHidden = true
                    viewFloatingFitnessInfo.isHidden = false
                    btnFitnessInfo.setTitleColor(blackColor, for: UIControlState())
                    btnEdit.isHidden = true
                    btnPersonalInfo.setTitleColor(greyColor, for: UIControlState())
                }else{
                    viewFloatingPersonalInfo.isHidden = false
                    btnPersonalInfo.setTitleColor(blackColor, for: UIControlState())
                    btnEdit.isHidden = false
                    btnFitnessInfo.setTitleColor(greyColor, for: UIControlState())
                    viewFloatingFitnessInfo.isHidden = true
                }
            }else{
                if previousViewControllers.first is TrainerProfileViewController{
                    viewFloatingPersonalInfo.isHidden = true
                    viewFloatingFitnessInfo.isHidden = false
                    btnFitnessInfo.setTitleColor(blackColor, for: UIControlState())
                    btnEdit.isHidden = true
                    btnPersonalInfo.setTitleColor(greyColor, for: UIControlState())
                }else{
                    viewFloatingPersonalInfo.isHidden = false
                    btnPersonalInfo.setTitleColor(blackColor, for: UIControlState())
                    btnEdit.isHidden = false
                    btnFitnessInfo.setTitleColor(greyColor, for: UIControlState())
                    viewFloatingFitnessInfo.isHidden = true
                }
            }
            
        }
        
        
    }
    
    //MARK::- Actions
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        popVC()
    }
    
    @IBAction func btnActionPersonalInfo(_ sender: UIButton) {
        btnEdit.isHidden = false
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return }
        sender.setTitleColor(blackColor, for: UIControlState())
        btnFitnessInfo.setTitleColor(greyColor, for: UIControlState())
        viewFloatingPersonalInfo.isHidden = false
        viewFloatingFitnessInfo.isHidden = true
        sender.tag = 0
        if isClient{
            guard let clientPersonalInfo = clientPersonalInfo else {return}
            setViewController(clientPersonalInfo, sender: sender)
        }else{
            guard let trainerProfileVc = trainerProfileVc else {return}
            setViewController(trainerProfileVc, sender: sender)
        }
        
        
    }
    
    @IBAction func btnActionFitnessInfo(_ sender: UIButton) {
        btnEdit.isHidden = true
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return }
        
        sender.tag = 1
        sender.setTitleColor(blackColor, for: UIControlState())
        viewFloatingPersonalInfo.isHidden = true
        viewFloatingFitnessInfo.isHidden = false
        btnPersonalInfo.setTitleColor(greyColor, for: UIControlState())
        if isClient{
            guard let clientSettings = clientSettings else {return}
            setViewController(clientSettings, sender: sender)
        }else{
            guard let trainerSettingsVc = trainerSettingsVc else {return}
            setViewController(trainerSettingsVc, sender: sender)
        }
        
        
    }
    
    
    @IBAction func btnActionEdit(_ sender: UIButton) {
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
        if edit{
            edit = false
            labelUserName.isEnabled = false
            guard let trainerProfileVc = trainerProfileVc else {return}
            guard let clientPersonalInfo = clientPersonalInfo else {return}
            if isClient{
                guard let cell = clientPersonalInfo.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ClientPersonalInfoTableViewCell else {return}
                cell.labelEmail.isEnabled = true
                cell.labelAddress.isEnabled = true
                cell.labelPhoneNumber.isEnabled = true
                cell.labelName.isEnabled = true
                cell.textFieldPinCode.isEnabled = true
                cell.textFieldCity.isEnabled = true
                cell.btnDate.isEnabled = true
                cell.btnState.isEnabled = true
            }else{
                labelUserName.isEnabled = true
                guard let cell = trainerProfileVc.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TrainerProfileTableViewCell else {return}
                cell.labelEmailId.isEnabled = true
                cell.labelAddress.isEnabled = true
                cell.labelPhoneNumber.isEnabled = true
                cell.textFieldZipCode.isEnabled = true
                cell.textFieldCity.isEnabled = true
                cell.btnState.isEnabled = true
            }
            sender.setTitle("SAVE", for: UIControlState())
            sender.setImage(UIImage(), for: UIControlState())
        }else{
            
            if isClient{
                editDetailOfClient()
            }else{
                
                editDetails()
            }
            
            
            
        }
        
        
        
    }
    
    
    
}


extension ClientsInfoViewController{
    
    //MARK::- CAMERA
    func callFusumaImagePicker(_ item:String){
        allowRev = false
        CameraGalleryPickerBlock.sharedInstance.pickerImage(type: item, presentInVc: self, pickedListner: {
            [weak self]
            (image,imageUrl) -> () in
            print(image)
            self?.imageUser.image = image
            }, canceledListner: {} , allowEditting:true)
        
    }
    
    //MARK::- API
    
    func editDetailOfClient(){
        
        
        guard let clientPersonalInfo = clientPersonalInfo else {return}
        guard let cell = clientPersonalInfo.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ClientPersonalInfoTableViewCell else {return}
        
        guard let usrName = cell.labelName.text?.lowercasedFirst() else {
            AlertView.callAlertView("", msg: "Please enter name", btnMsg: "OK", vc: self)
            return}
        let names = usrName.split(" ")
        var firstName = ""
        var lastName = ""
        if names.count == 2{
            firstName = names[0].lowercasedFirst()
            lastName = names[1].uppercaseFirst
        }else{
            firstName = usrName
        }
        
        let _ = ClientEditDetails(firstName: firstName, lastName: lastName, phoneNumber: cell.labelPhoneNumber.text, countryCode: "+1", address: cell.labelAddress.text, email: cell.labelEmail.text, pinCode: cell.textFieldPinCode.text, state: cell.btnState.titleLabel?.text, city: cell.textFieldCity.text)
        let checkValidation = ClientEditDetails.getValidationResult()
        
        if checkValidation{
            var dictForBackEnd = createdDict
            
            dictForBackEnd?["age"] = cell.labelAge.text as AnyObject?
            
            print(dictForBackEnd)
            
            ApiDetector.getDataOfURL(ApiCollection.apiClientSaveEditting, dictForBackend: dictForBackEnd, failure: { (data) in
                print(data)
                }, success: { [weak self] (data) in
                    print(data)
                    guard let cell = clientPersonalInfo.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ClientPersonalInfoTableViewCell else {return}
                    cell.labelEmail.isEnabled = false
                    cell.btnDate.isEnabled = false
                    cell.labelAddress.isEnabled = false
                    cell.labelPhoneNumber.isEnabled = false
                    cell.labelName.isEnabled = false
                    cell.textFieldPinCode.isEnabled = false
                    cell.textFieldCity.isEnabled = false
                    cell.btnState.isEnabled = false
                    self?.labelUserName.isEnabled = false
                    self?.labelUserName.text = firstName.uppercaseFirst + " " + lastName.uppercaseFirst
                    self?.edit = true
                    self?.btnEdit.setImage(UIImage(named: "ic_edit_white"), for: UIControlState())
                    self?.btnEdit.setTitle("", for: UIControlState())
                    clientPersonalInfo.getPersonalDetails(false)
                    self?.getPersonalDetails(false)
                    AlertView.callAlertView("", msg: "Changes successfully saved.", btnMsg: "OK", vc: self ?? UIViewController())
                }, method: .postWithImage, viewControl: self, pic: self.imageUser.image, placeHolderImageName: "profilePic", headers: [:], showLoader: true, loaderColor: Colorss.darkRed.toHex())
            
        }else{
            AlertView.callAlertView("", msg: "Please enter complete and valid information", btnMsg: "OK", vc: self)
        }
        
    }
    
    
    func editDetails(){
        
        guard let trainerProfileVc = trainerProfileVc else {return}
        guard let cell = trainerProfileVc.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TrainerProfileTableViewCell else {return}
        
        
        
        //        guard let phnNo = cell.labelPhoneNumber.text?.uppercaseFirst else{
        //            AlertView.callAlertView("", msg: "Please enter valid phoneNumber", btnMsg: "OK", vc: self)
        //            return
        //        }
        //        if phnNo == ""{
        //            AlertView.callAlertView("", msg: "Please enter valid phoneNumber", btnMsg: "OK", vc: self)
        //            return
        //        }else{
        //
        //        }
        //
        //
        //        guard let address = cell.labelAddress.text else{
        //            AlertView.callAlertView("", msg: "Please enter address", btnMsg: "OK", vc: self)
        //            return
        //        }
        //
        //        if address == ""{
        //            AlertView.callAlertView("", msg: "Please enter address", btnMsg: "OK", vc: self)
        //            return
        //        }else{
        //
        //        }
        guard var usrName = labelUserName.text?.lowerCaseFirst else {return}
        
        if usrName == ""{
            AlertView.callAlertView("", msg: "Please enter name", btnMsg: "OK", vc: self)
            return
        }
        
        var names = usrName.split(" ")
        var firstName = ""
        var lastName = ""
        if names.count == 2{
            firstName = names[0].lowerCaseFirst
            lastName = names[1].uppercaseFirst
        }else{
            firstName = usrName
        }
        
        
        let _ = ClientEditDetails(firstName: firstName, lastName: lastName, phoneNumber: cell.labelPhoneNumber.text, countryCode: "+1", address: cell.labelAddress.text, email: cell.labelEmailId.text, pinCode: cell.textFieldZipCode.text, state: cell.btnState.titleLabel?.text, city: cell.textFieldCity.text)
        let checkValidation = ClientEditDetails.getValidationResult()
        
        
        //        guard let emailAddrs = cell.labelEmailId.text else{
        //            AlertView.callAlertView("", msg: "Please enter valid email address", btnMsg: "OK", vc: self)
        //            return
        //        }
        //        if emailAddrs == ""{
        //            AlertView.callAlertView("", msg: "Please enter valid email address", btnMsg: "OK", vc: self)
        //            return
        //        }
        //        if User.isValidEmail(emailAddrs){}else{
        //            AlertView.callAlertView("", msg: "Please enter valid email address", btnMsg: "OK", vc: self)
        //        }
        
        if checkValidation{
            let dictForBackEnd = createdDict
            
            print(dictForBackEnd)
            ApiDetector.getDataOfURL(ApiCollection.apiSaveEditting, dictForBackend: dictForBackEnd, failure: { (data) in
                print(data)
                }, success: { [unowned self] (data) in
                    print(data)
                    cell.labelEmailId.isEnabled = false
                    cell.labelAddress.isEnabled = false
                    cell.labelPhoneNumber.isEnabled = false
                    cell.textFieldZipCode.isEnabled = false
                    cell.textFieldCity.isEnabled = false
                    cell.btnState.isEnabled = false
                    self.edit = true
                    self.btnEdit.setImage(UIImage(named: "ic_edit_white"), for: UIControlState())
                    self.btnEdit.setTitle("", for: UIControlState())
                    self.labelUserName.isEnabled = false
                    self.labelUserName.text = firstName.uppercaseFirst + " " + lastName.uppercaseFirst
                    trainerProfileVc.getTrainerProfile(false)
                    self.getPersonalDetails(false)
                    AlertView.callAlertView("", msg: "Changes successfully saved.", btnMsg: "OK", vc: self)
                }, method: .postWithImage, viewControl: self, pic: imageUser.image, placeHolderImageName: "profilePic", headers: [:], showLoader: true, loaderColor: Colorss.darkRed.toHex())
        }else{
            
        }
        
        
    }
    
    @IBAction func btnActionEditImage(_ sender: UIButton) {
        if edit{
            
        }else{
            let alertcontroller =   UIAlertController.showActionSheetController(title: "Choose you action", buttons: ["Camera" , "Photo Library"], success: { [weak self]
                (state) -> () in
                self?.callFusumaImagePicker(state)
                })
            present(alertcontroller, animated: true, completion: nil)
        }
    }
    
}


extension String {
    
    func split(regex pattern: String) -> [String] {
        
        guard let re = try? NSRegularExpression(pattern: pattern, options: [])
            else { return [] }
        
        let nsString = self as NSString // needed for range compatibility
        let stop = "<SomeStringThatYouDoNotExpectToOccurInSelf>"
        let modifiedString = re.stringByReplacingMatches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: nsString.length),
            withTemplate: stop)
        return modifiedString.components(separatedBy: stop)
    }
}


extension ClientsInfoViewController{
    
    func getPersonalDetails(_ showLoader: Bool){
        var url = ""
        guard let isClient = UserDataSingleton.sharedInstance.loggedInUser?.isClient else {return}
        if isClient{
            url = ApiCollection.apiClientProfile
        }else{
            url = ApiCollection.apiTrainerProfile
        }
        let dictForBackEnd = API.ApiCreateDictionary.broadCastListing().formatParameters()
        ApiDetector.getDataOfURL(url, dictForBackend: dictForBackEnd, failure: { (data) in
            print(data)
            }, success: { [weak self] (data) in
                print(data)
                self?.boolBlockApi = true
                if isClient{
                    guard let data = data as? ClientPersonalInfo else {return}
                    self?.labelUserName.text = (data.firstName?.uppercaseFirst ?? "") + " " + (data.lastName?.uppercaseFirst ?? "")
                    let singletonData = UserDataSingleton.sharedInstance.loggedInUser
                    singletonData?.userImage?.userOriginalImage = data.userImage?.userOriginalImage
                    singletonData?.userImage?.userThumbnailImage = data.userImage?.userThumbnailImage
                    guard let firstName = data.firstName?.uppercaseFirst , let last = data.lastName?.uppercaseFirst else {return}
                    singletonData?.name = firstName + " " + last
                    UserDataSingleton.sharedInstance.loggedInUser = singletonData
                    
                    print(UserDataSingleton.sharedInstance.loggedInUser?.name)
                    print(UserDataSingleton.sharedInstance.loggedInUser?.userImage?.userOriginalImage)
                    
                    let imgUrl = data.userImage?.userOriginalImage
                    let imageUrl = URL(string: ApiCollection.apiImageBaseUrl + (imgUrl ?? ""))
                    self?.imageUser.yy_setImage(with: imageUrl, placeholder: UIImage(named: "ic_placeholder"))
                }else{
                    guard let data = data as? TrainerProfile else {return}
                    self?.labelUserName.text = (data.firstName?.uppercaseFirst ?? "") + " " + (data.lastName?.uppercaseFirst ?? "")
                    let singletonData = UserDataSingleton.sharedInstance.loggedInUser
                    singletonData?.userImage?.userOriginalImage = data.userImage?.userOriginalImage
                    singletonData?.userImage?.userThumbnailImage = data.userImage?.userThumbnailImage
                    guard let firstName = data.firstName?.uppercaseFirst , let last = data.lastName?.uppercaseFirst else {return}
                    singletonData?.name = firstName + " " + last
                    UserDataSingleton.sharedInstance.loggedInUser = singletonData
                    
                    print(UserDataSingleton.sharedInstance.loggedInUser?.name)
                    print(UserDataSingleton.sharedInstance.loggedInUser?.userImage?.userOriginalImage)
                    
                    let imgUrl = data.userImage?.userOriginalImage
                    let imageUrl = URL(string: ApiCollection.apiImageBaseUrl + (imgUrl ?? ""))
                    self?.imageUser.yy_setImage(with: imageUrl, placeholder: UIImage(named: "ic_placeholder"))
                }
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "ConfigureLeftDrawer"), object: nil)
                
            }, method: .post, viewControl: self, pic: UIImage(), placeHolderImageName: "", headers: [:] , showLoader: showLoader, loaderColor: Colorss.darkRed.toHex())
    }
}
