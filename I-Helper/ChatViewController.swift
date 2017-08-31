//
//  ChatViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 14/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
import Alamofire

final class ChatViewController:JSQMessagesViewController  {

    // MARK: Properties
    
    
    var channelRef: DatabaseReference?
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    private lazy var messageRef: DatabaseReference = self.channelRef!.child("messages")
    private var newMessageRefHandle: DatabaseHandle?
    
    var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    var chatRoomId:String?
    private let imageURLNotSetKey = "NOTSET"

     private var updatedMessageRefHandle: DatabaseHandle?
    var messages = [JSQMessage]()
    
    
    private lazy var userIsTypingRef: DatabaseReference =
        self.channelRef!.child("typingIndicator").child(self.senderId) // 1
    private var localTyping = false // 2
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            // 3
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    
    private lazy var usersTypingQuery: DatabaseQuery =
        self.channelRef!.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = Auth.auth().currentUser?.uid
        
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        observeMessages()
    }
    
    
    deinit {
        if let refHandle = newMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
        
        if let refHandle = updatedMessageRefHandle {
            messageRef.removeObserver(withHandle: refHandle)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        observeTyping()
    }
    
    // MARK: Collection view data source (and related) methods
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    // MARK: Firebase related methods
    
    
    // MARK: UI and User Interaction
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    
    private func addPhotoMessage(withId id: String, key: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: id, displayName: "", media: mediaItem) {
            messages.append(message)
            
            if (mediaItem.image == nil) {
                photoMessageMap[key] = mediaItem
            }
            
            collectionView.reloadData()
        }
    }
    
    func sendPhotoMessage() -> String? {
        let itemRef = messageRef.childByAutoId()
        let dateStamp:TimeInterval = Date().timeIntervalSince1970 * 1000
        
        let messageItem = [ // 2
            "sender_id": senderId!,//sender userId
            "name": senderDisplayName!,//Sender name
            "message": imageURLNotSetKey,//URL in case of image
            "photoURL": imageURLNotSetKey,//URL in case of image
            "date":"\(dateStamp)",//timestamp  13 degit
            "type":"0"//text message 1 image url 0
        ]
        itemRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
        return itemRef.key
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = messageRef.childByAutoId() // 1
        
        let dateStamp:TimeInterval = Date().timeIntervalSince1970 * 1000
        let messageItem = [ // 2
            "sender_id": senderId!,//sender userId
            "name": senderDisplayName!,//Sender name
            "message": text!,//URL in case of image
            "date":"\(dateStamp)",//timestamp  13 degit
            "type":"1"//text message 1 image url 0
            ]
        
        itemRef.setValue(messageItem) // 3
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        
        finishSendingMessage() // 5
        
        isTyping = false
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        
        let actionCtrl = UIAlertController(title: "Select Image", message: "Chosse the option", preferredStyle: .actionSheet)
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { [weak self](action) in
            self?.openImageController(isFromCamera: true)
        }
        actionCtrl.addAction(actionCamera)
        let actionGallery = UIAlertAction(title: "Gallery", style: .default) { [weak self](action) in
            self?.openImageController(isFromCamera: false)
        }
        actionCtrl.addAction(actionGallery)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionCtrl.addAction(actionCancel)
        
        present(actionCtrl, animated: true, completion: nil)
    }
    
    func openImageController(isFromCamera:Bool)  {
        let picker = UIImagePickerController()
        picker.delegate = self
        if (isFromCamera) {
            picker.sourceType = UIImagePickerControllerSourceType.camera
        } else {
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        present(picker, animated: true, completion:nil)

    }
     func observeMessages() {
        messageRef = channelRef!.child("messages")
        
        // 1.
        let messageQuery = messageRef.queryLimited(toLast:25)
        
        // 2. We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            // 3
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if let id = messageData["sender_id"] as String!, let type = messageData["type"] as String!, type == "1",let name = messageData["name"] as String!, let text = messageData["message"] as String!, text.characters.count > 0 {
                // 4
                self.addMessage(withId: id, name: name, text: text)
                
                // 5
                self.finishReceivingMessage()
            }
            else if let id = messageData["sender_id"] as String!, let type = messageData["type"] as String!, type == "0",
                let photoURL = messageData["photoURL"] as String! { // 1
                // 2
                if let mediaItem = JSQPhotoMediaItem(maskAsOutgoing: id == self.senderId) {
                    // 3
                    self.addPhotoMessage(withId: id, key: snapshot.key, mediaItem: mediaItem)
                    // 4
                    if photoURL.hasPrefix("http://") {
                        self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: nil)
                    }
                }
            }
            else {
                print("Error! Could not decode message data")
            }
        })
        
        
        // We can also use the observer method to listen for
        // changes to existing messages.
        // We use this to be notified when a photo has been stored
        // to the Firebase Storage, so we can update the message data
        updatedMessageRefHandle = messageRef.observe(.childChanged, with: { (snapshot) in
            let key = snapshot.key
            let messageData = snapshot.value as! Dictionary<String, String> // 1
            
            if let photoURL = messageData["photoURL"] as String! { // 2
                // The photo has been updated.
                if let mediaItem = self.photoMessageMap[key] { // 3
                    self.fetchImageDataAtURL(photoURL, forMediaItem: mediaItem, clearsPhotoMessageMapOnSuccessForKey: key) // 4
                }
            }
        })
        
    }
    
    private func observeTyping() {
        let typingIndicatorRef = channelRef!.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        
        // 1
        usersTypingQuery.observe(.value) { (data: DataSnapshot) in
            // 2 You're the only one typing, don't show the indicator
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            
            // 3 Are there others typing?
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottom(animated: true)
        }
    }
    
    
    func setImageURL(_ url: String, forPhotoMessageWithKey key: String) {
        let itemRef = messageRef.child(key)
        itemRef.updateChildValues(["photoURL": url])
    }
    
    func deleteChatImage(forPhotoMessageWithKey key: String)  {
        let itemRef = messageRef.child(key)
        itemRef.removeValue()
    }
    
    
    private func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
        
        let url = URL(string: photoURL)
        
        Alamofire.request(url!).responseData{ (response) in
            if response.error == nil {
                if let data = response.data {
                    // 4
                    /*if (response.contentType == "image/gif") {
                        mediaItem.image = UIImage.gifWithData(data)
                    } else {*/
                        mediaItem.image = UIImage.init(data: data)
                    
                    //}
                    self.collectionView.reloadData()
                    
                    // 5
                    guard key != nil else {
                        return
                    }
                    self.photoMessageMap.removeValue(forKey: key!)
                }
            }
        }
        
        
    }
    // MARK: UITextViewDelegate methods
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        isTyping = textView.text != ""
    }
    
    func showAlertMessage(title: String, message:String, isSuccess:Bool)  {
        let alertCtrl = UIAlertController(title:title , message: message, preferredStyle: .alert)
        var alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        if isSuccess {
            alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self](action) in
                DispatchQueue.main.async {
                    self?.dismiss(animated: true, completion: nil)
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            })
        }
        alertCtrl.addAction(alertAction)
        self.present(alertCtrl, animated: true, completion: nil)
    }
}

// MARK: Image Picker Delegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        // 1
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // 2
        if let key = sendPhotoMessage() {
            // 3
            guard let imageData = UIImageJPEGRepresentation(image, 1.0) else { return }
           
            NetworkClient.shared.uploadImage(apiname: "uploadChatImage", params: nil, imageData: imageData, success: { (response) in
                //if let response = response  {
                    print(response)
                    if let imageURL = response["data"] as? String{
                        self.setImageURL(imageURL, forPhotoMessageWithKey: key)
                    }
                    else{
                        if let message = response["message"] as? String{
                            self.showAlertMessage(title: "Error!!", message: message, isSuccess: false)
                            self.deleteChatImage(forPhotoMessageWithKey: key)
                        }
                        
                    }
                //}
            }, failure: { (error) in
                print(error)
            })
        }
        picker.dismiss(animated: true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
    
}
