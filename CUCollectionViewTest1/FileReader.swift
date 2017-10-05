//
//  FileReader.swift
//  collectionViewTest
//
//  Created by Sujeet.Kumar on 10/4/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

import Foundation


class FileReader {
    class func getFileData(at filePath:String) ->Data? {
        var jsonData:Data? = nil
        do {
            if let file = Bundle.main.url(forResource: filePath, withExtension: "json") {
                let data = try Data(contentsOf: file)
                jsonData = data
            }else{
                print("file not found!!")
            }
        }catch{
            print("content of file not converted to data.")
        }
        return jsonData
    }
}
