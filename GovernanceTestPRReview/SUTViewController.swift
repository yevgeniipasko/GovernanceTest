import UIKit

// Hi there. Is any other good place to move isIPhone method to make it more generic and not to rely on it like only one class under the view controller
// Would you mind to update the method name to make it to be more concrete on the purpose of usage. Then you will probably have the possibility to update the name to some kind of isPhone. Taking into consideration that phone could be as iPhone as iPod the name isIPhone is not fully correct in this case
func isIPhone() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}

// 1. Could you please update someVC to something more concrete that explains the purpose of its usage.
// 2. View controller name as type name should be prefixed with uppercased latter
// 3. Update the identation to follow the standard rules across the project
// 4. Would you mind to separate inherited classes and protocols with space?
class someVC: UIViewController,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    // Every of the view or constraint that is defined and is hold by view should not be defined as strong link. Can you please verify and update the code to be used with weak links and only the cases where you know that no holder will be defined use strongs.
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var detailViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var detailView: UIView!
 
    // Could you please remove the space before definition of the type for both lines below.
    // detailVC : UIViewController? - > detailVC: UIViewController?
    var detailVC : UIViewController?
    // Do you think is it better to update this array to have type strictly defined? If not then can you please explain why?
    var dataArray : [Any]?
    
    // Super viewWillAppear is not called for the subclass.
    override func viewWillAppear(_ animated: Bool) {
        
        // Are you sure that you want to perform fetch of the data on each screen appearing? Maybe it is better to put it to view did load?
        fetchData()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        // Could you please separate definition of UINib to separated constant?
        // Could you please use constants for identifying the nibName and reuse identifiers?
        self.collectionView.register(UINib(nibName: "someCell",
                        bundle: nil), forCellWithReuseIdentifier: "someCell")
        // Could you please separate definition of UIBarButtonItem to separated constant?
        // It is not required to call .init directly. You can just use UIBarButtonItem(title:
        // Can you please make sure that you have space after each 'title:' before defining the object
        // I think it would be better to move NSLocalizedString somewhere separated where all localization is performed with keys
        // Could you please fix typo dissmissController -> dismissController and update the name of the method in correspondece what controller needs to be dismissed
        self.navigationItem.rightBarButtonItem = NSLocalizedString UIBarButtonItem.init(title:NSLocalizedString("Done", comment: ""), style: .plain, target: self, action: #selector(dissmissController))
        
    }
  
    @objc func dissmissController () {}
    
    func fetchData() {
        // Do you think will it be better to do these updates:
        // 1. Move the string URL to constant
        // 2. Exclude force unwrapp please and make it with optional. Then please, unwrapp it with if let or guard statement.
        // 3. The Backtick symbol will not be recognized by the compiler. Would you mind updating it please to default quotes? Thanks
        let url = URL(string: “testreq")!
                      
        // 1. It is not required for the task to specify self as parameter. It could be used by default. Also this self will not create reference cycle taking into consideration we use it on the shared instance of url session object
        // 2. You can exclude braces because they are not obligatory in the passing parameters
        // 3. The clousure should not take response and error objects as they are not used into the closure. Feel free to replace '[self](data, response, error) in' with 'data, _, _ in'. Also much better will be if you can parse the error and response with the code and log it
        // 4. Could you please think if it is possible to make naming for the task and data to be much more concrete. For ex: pictureDownloadTask, pictureData
      let task = URLSession.shared.dataTask(with: url) { [self](data, response, error) in

        // 5. It is better to decode the data here with codable or decode to image instead of parsing data to [Any] because the data could be various in each of the case.
            self.dataArray = data as? [Any]
        // 6. UI updates should be executed on the main thread. And please, make sure that you want to update UI from the result closure of backend request that is not preffered to do. Make separated method and callback to make UI to be more separated from the call
            self.collectionView.reloadData()
        }
                      task.resume()
                  }
                      
        // Can you please make idents for every line to be with the styleguide of the project. Feel free to use control+i
        // Could you please follow guideline and use camelcase for methods definiton
        // Remove please space before parentheses to follow the styleguide
                      @IBAction func closeshowDetails () {
        // Do you think is it better to define constants on the top level of the class or separated structure to make it easier to understand when details are hidden or presented. The same for the time delay
                              self.detailViewWidthConstraint.constant = 0

                              UIView.animate(withDuration: 0.5, animations:
                                              {
                                 
                                  self.view.layoutIfNeeded()
                                  
                              })
        // Please dont use trainilg closure in this case because there is no obious understanding what the method is.
        // Would you mind to remove completed or use it if it is needed because currently it is defined but is not used that can execute something when the animation is not completed
                              { (completed) in
                                  self.detailVC?.removeFromParent()
                              }
                          }
        // I expect there is typo here again about of detail. showDetail should be showDetails
                          @IBAction func showDetail () {
        // Do you think is it better to define constants on the top level of the class or separated structure to make it easier to understand when details are hidden or presented. The same for the time delay
                              self.detailViewWidthConstraint.constant = 100
                              
                              UIView.animate(withDuration: 0.5, animations:
                                              {
                                 
                                  self.view.layoutIfNeeded()
                                  
                              })
        // Would you mind to remove completed or use it if it is needed because currently it is defined but is not used that can execute something when the animation is not completed
                              { (completed) in
                                  self.view.addSubview(self.detailView)
                              }
        // My expectation is that we need to add parent if you remove the parent in the previous method.
        // My suggestion is to update the order of these methods and add the parent if it is required here
                          }

                            open func collectionView(_ collectionView: UICollectionView,
                                                   layout collectionViewLayout: UICollectionViewLayout,
                                                   sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Do you think is it better to define constants on the top level of the class or separated structure to make it easier to be followed and to prevent duplication and only then to assign variables
                              var widthMultiplier: CGFloat = 0.2929
                              if isIPhone() {
                                  widthMultiplier = 0.9
                              }
        // Extra space is used after widthMultiplier.
        // Also, could you please align parameters according to the project guideline
                              return CGSize(width: view.frame.width * widthMultiplier ,
                                            height:  150.0)
                          }
        // Could you please align parameters according to the project guideline
                          func collectionView(_ collectionView: UICollectionView, layout
                                              collectionViewLayout: UICollectionViewLayout,
                                              minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Do you think is it better to define constants on the top level of the class or separated structure to make it easier to be followed and to prevent duplication and only then to assign variables
                              let frameWidth = (view.frame.width * 0.2929 * 3) + 84
        // Can you please update this part accoring to the project code styleguide (view.frame.width - frameWidth)/2? We need to have spaces between the digit
                              var minSpacing: CGFloat = (view.frame.width - frameWidth)/2
                              if isIPhone() {
                                  minSpacing = 24
                              }
                              return minSpacing
                          } // By default in iOS we are separating the methods with empty lines. Can you please follow this guide for all methods you have in the project?
                          func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                              return  self.dataArray?.count ?? 0
                          }
                      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Are we really going to precent empty cells? Because the implementation and configuring is missed and should be handled properly for the collection view. Let me know please if you are going to add it in the future.
                              return UICollectionViewCell()
                          }
                          func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                              self.showDetail()
                          } // if we want to go with the default styleguide then empty line should be added before the closed class brace
                      }


_____________________________________________________________________________________
// Thank you for the effort. I made few comments and would appreciate it if you can review them
