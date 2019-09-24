/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import UIKit
import CloudKit

class SettingsScreen : UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Outlets
    @IBOutlet weak var tableView : UITableView!
    
    // Properties
    private let sections = [ "Profile", "Sound", "Visuals", "Credits" ]
    private let profile  = [ "Display Name", "Avatar"                 ]
    private let sound    = [ "Track"]
    
    internal var player    : Player!
    internal var container : CKContainer!
    
    // Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Look out for iCloud sign in and out while app is in use
        NotificationCenter.default.addObserver( self,
            selector : #selector( userChanged ),
            name     : Notification.Name.CKAccountChanged,
            object   : nil
        )
        
        // Register SettingsHeader.xib as a reusable header
        tableView.register(
            UINib.init( nibName : ReusableCell.SettingsHeader.description, bundle : nil ),
            forHeaderFooterViewReuseIdentifier : ReusableCell.settingsHeader.description
        )
    }
    
    // Handle iCloud sign in and out by dismissing alerts and this screen
    @objc func userChanged() {
        DispatchQueue.main.async {
            if let vc = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController,
                vc.isKind( of : UIAlertController.self ) {
                vc.dismiss( animated : true, completion : nil )
            }
            
            self.navigationController?.popViewController( animated : true )
        }
    }
    
    func tableView( _ tableView : UITableView, numberOfRowsInSection section : Int ) -> Int {
        switch section {
            case 0  : return profile.count
            default : return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView( _ tableView : UITableView, estimatedHeightForHeaderInSection section : Int ) -> CGFloat {
        return 44
    }
    
    func tableView( _ tableView : UITableView, viewForHeaderInSection section : Int ) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier : ReusableCell.settingsHeader.description ) as? SettingsHeader {
            
            header.label.text = sections[ section ]
            
            return header
        }
        
        return nil
    }
    
    func tableView( _ tableView : UITableView, cellForRowAt indexPath : IndexPath ) -> UITableViewCell {
        if indexPath.section == 0,
            let cell    = tableView.dequeueReusableCell( withIdentifier : ReusableCell.selectableSetting.description ) {
                
            let row  = indexPath.row
            
            cell.textLabel?.text       = profile[ row ]
            
            cell.detailTextLabel?.text = { switch row {
                case 0  : return player.displayName
                default : return player.avatar.description.capitalized
            } }()
            
            if player is GuestPlayer { cell.accessoryType = .none }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_  tableView : UITableView, didSelectRowAt indexPath : IndexPath ) {
        if indexPath.section == 0, let signedIn = player as? SignedInPlayer {
            if indexPath.row == 0 {
                let alert = UIAlertController(
                    title          : "Display Name",
                    message        : "Enter a new display name.  Blank entries will be ignored.",
                    preferredStyle : .alert
                )
                
                alert.addTextField { field in field.placeholder = "Display Name" }
                
                let cancel = UIAlertAction( title : "Cancel", style : .cancel  ) { _ in }
                
                let apply  = UIAlertAction( title : "Apply",  style : .default ) { _ in
                    let field = alert.textFields!.first
                    
                    if field?.text != "" {
                        signedIn.displayName = field?.text
                        tableView.reloadData()
                    }
                }
                
                alert.addAction( cancel )
                alert.addAction( apply  )
                self.present( alert, animated : true, completion : nil )
            } else {
                let alert = UIAlertController(
                    title          : nil,
                    message        : "Choose an Avatar",
                    preferredStyle : .actionSheet
                )
                
                let cancel = UIAlertAction( title : "Cancel", style : .cancel )
                
                Avatar.allCases.forEach { avatar in
                    let action = UIAlertAction( title : avatar.rawValue.capitalized, style : .default ) { _ in
                        signedIn.avatar = avatar
                        tableView.reloadData()
                    }
                    
                    alert.addAction( action )
                }
                
                alert.addAction( cancel )
                
                if let popover = alert.popoverPresentationController {
                    popover.sourceView = tableView.cellForRow( at : indexPath )
                    popover.sourceRect = tableView.cellForRow( at : indexPath )!.bounds
                }
                
                self.present( alert, animated : true, completion : nil )
            }
        }
    }
}
