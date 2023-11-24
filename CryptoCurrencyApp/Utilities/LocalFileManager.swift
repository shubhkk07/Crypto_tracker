//
//  LocalFileManager.swift
//  CryptoCurrencyApp
//
//  Created by Shubham Choudhary on 24/07/23.
//

import Foundation
import SwiftUI

class LocalFileManager{
    
    static let instance = LocalFileManager()
    
    private init(){}
    
    func saveImage(image: UIImage, imageName: String, folderName: String){
        //create folder
        createfolderIfNeeded(folderName: folderName)
        
        //get path for image
        guard let data = image.pngData(),
              let url = getUrlForImage(imageName: imageName, folderName: folderName)
        else {return}
        
        //Save Image
        do {
            try data.write(to: url)
        } catch let error {
            print("error. \(error.localizedDescription)")
        }
    }
    
    func getImage(imageName:String, folderName:String) -> UIImage? {
        guard
            let url = getUrlForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path)
        else {return nil}
        
        
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createfolderIfNeeded(folderName: String){
        guard let url = getURLForFolder(folderName: folderName) else {return}
        
        if(!FileManager.default.fileExists(atPath: url.path)){
            do {
                try  FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let error {
                print("error \(error.localizedDescription)")
            }
           
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else {return nil}
        
        return url.appendingPathComponent(folderName)
    }
    
    private func getUrlForImage(imageName:String,folderName:String) -> URL?{
        guard let url = getURLForFolder(folderName: folderName)
        else {return nil}
        return url.appendingPathComponent(imageName + ".png")
    }
}
