//
//  ImageSaver.swift
//  ElektroluxApp
//
//  Created by Mehmet Seyhan on 05/05/2022.
//

import SwiftUI

class ImageSaver: NSObject {
    
    //write it into Library
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    // check if error exists or not that notify listener
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let imageStatus = true
        NotificationCenter.default.post(name: .savingImageInLibrary, object: imageStatus)

        print("Save finished!")
    }
}
