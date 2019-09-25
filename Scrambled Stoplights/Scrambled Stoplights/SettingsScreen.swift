/*
 David Clark -
 Development Porfolio 4 (DVP4)
 MDV349-O, C201909-01
 Scrambled Stoplights
 2019-09-11 to 2019-XX-XX
 */

import UIKit
import CloudKit

class SettingsScreen : UITableViewController {
    // Outlets
    @IBOutlet weak var displayName : UILabel!
    @IBOutlet weak var avatar      : UILabel!
    @IBOutlet weak var track       : UILabel!
    @IBOutlet weak var theme       : UILabel!
    
    @IBOutlet weak var music       : UISlider!
    @IBOutlet weak var sounds      : UISlider!
    
    @IBOutlet      var preview     : [ UIImageView ]!
    
    // Properties

    internal var player    : Player!
    internal var container : CKContainer!
    
    private  var bulbs     = [
        Bulb( ofType : .stop, withWeight : .one   ),
        Bulb( ofType : .slow, withWeight : .two   ),
        Bulb( ofType : .go,   withWeight : .three ),
        Bulb( ofType : .empty ),
        Bulb( ofType : .clear ),
        Bulb( ofType : .ghost )
    ]
    
    // Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromSettings()
        previewBulbs()
        
        // Look out for iCloud sign in and out while app is in use
        NotificationCenter.default.addObserver(
            self,
            selector : #selector( userChanged ),
            name     : Notification.Name.CKAccountChanged,
            object   : nil
        )
    }
    
    override func tableView( _ tableView : UITableView, heightForRowAt indexPath : IndexPath ) -> CGFloat {
        if indexPath.section == 0 && player is GuestPlayer { return 0 }
        
        return 44
    }
    
    override func tableView( _ tableView : UITableView, heightForHeaderInSection section : Int ) -> CGFloat {
        if section == 0 && player is GuestPlayer { return 0 }
        
        return 24
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
    
    func loadFromSettings() {
        displayName.text = player.displayName
        avatar.text      = player.avatar.description.capitalized
        track.text       = Music.current.name.capitalized
        theme.text       = Theme.current.description.capitalized
        music.value      = Music.volume
        sounds.value     = Sound.volume
    }
    
    func previewBulbs() { for bulb in preview.enumerated() { bulb.element.image = bulbs[ bulb.offset ].image } }
    
    @IBAction func displayNameTapped( _ sender : UITapGestureRecognizer ) {
        if let signedIn = player as? SignedInPlayer {
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
                    signedIn.displayName  = field?.text
                    self.displayName.text = field?.text
                }
            }
        
            alert.addAction( cancel )
            alert.addAction( apply  )
            self.present( alert, animated : true, completion : nil )
        }
    }
    
    @IBAction func avatarTapped( _ sender : UITapGestureRecognizer ) {
        if let signedIn = player as? SignedInPlayer {
            let alert = UIAlertController(
                title          : nil,
                message        : "Choose an Avatar",
                preferredStyle : .actionSheet
            )
            
            let cancel = UIAlertAction( title : "Cancel", style : .cancel )
            
            Avatar.allCases.forEach { avatar in
                let action = UIAlertAction( title : avatar.rawValue.capitalized, style : .default ) { _ in
                    signedIn.avatar  = avatar
                    self.avatar.text = avatar.description.capitalized
                }
                
                alert.addAction( action )
            }
            
            alert.addAction( cancel )
            
            if let popover = alert.popoverPresentationController {
                popover.sourceView = avatar
                popover.sourceRect = avatar.bounds
            }
            
            self.present( alert, animated : true, completion : nil )
        }
    }
    
    @IBAction func trackTapped( _ sender : UITapGestureRecognizer ) {
        let alert = UIAlertController(
            title          : nil,
            message        : "Choose a Music Track",
            preferredStyle : .actionSheet
        )
        
        let cancel = UIAlertAction( title : "Cancel", style : .cancel )
        
        Music.allCases.forEach { track in
            let action = UIAlertAction( title : track.rawValue.capitalized, style : .default ) { _ in
                Music.specified  = track
                self.track.text = Music.current.name.capitalized
                
                Music.current.play()
                
                RunLoop.main.add(
                    Timer( timeInterval : 2, repeats : false, block : { _ in Music.stop() } ),
                    forMode : .default
                )
            }
            
            alert.addAction( action )
        }
        
        alert.addAction( cancel )
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = track
            popover.sourceRect = track.bounds
        }
        
        self.present( alert, animated : true, completion : nil )
    }
    
    @IBAction func themeTapped( _ sender : UITapGestureRecognizer ) {
        let alert = UIAlertController(
            title          : nil,
            message        : "Choose a Stoplight Theme",
            preferredStyle : .actionSheet
        )
        
        let cancel = UIAlertAction( title : "Cancel", style : .cancel )
        
        Theme.allCases.forEach { theme in
            let action = UIAlertAction( title : theme.rawValue.capitalized, style : .default ) { _ in
                Theme.specified = theme
                self.theme.text = Theme.current.description.capitalized
                
                self.previewBulbs()
            }
            
            alert.addAction( action )
        }
        
        alert.addAction( cancel )
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = theme
            popover.sourceRect = theme.bounds
        }
        
        self.present( alert, animated : true, completion : nil )
    }
    
    @IBAction func creditsTapped( _ sender : UITapGestureRecognizer ) {
        let alert = UIAlertController(
            title          : "About Scrambled Stoplights",
            message        : "Game Design by David Clark, Copyright 2019.\n\n"
                           + "Avatar Artwork provided by Full Sail University.\n\n"
                           + "Background Music by Eric Matyas at Soundimage.org.\n\n"
                           + "Sound Effects by ZAPSPLAT at zapsplat.com and Sound Jay at soundjay.com.",
            preferredStyle : .alert
        )
        
        alert.addAction( UIAlertAction( title : "Okay", style : .cancel  ) { _ in } )
        self.present( alert, animated : true, completion : nil )
    }
    
    @IBAction func musicVolumeChanged( _ sender : UISlider ) {
        Music.volume = sender.value
        
        Music.current.play()
        
        RunLoop.main.add(
            Timer( timeInterval : 2, repeats : false, block : { _ in Music.stop() } ),
            forMode : .default
        )
    }
    @IBAction func soundVolumeChanged( _ sender : UISlider ) {
        Sound.volume = sender.value
        
        Sound.chirp.play()
    }
}
