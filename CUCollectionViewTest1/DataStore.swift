//
//  DataSource.swift
//  CUCollectionViewTest1
//
//  Created by Sujeet.Kumar on 10/5/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

import Foundation
import ObjectMapper

enum dataType {
    case userText(String)
    case BotText(String)
    case packet(PacketData)
}


class DataStore {
    var dataArray:[dataType] = []
    
    init() {
        setUpDataSource()
    }

    
    /// to create data information - static
    func setUpDataSource() {
        let userchat = dataType.userText("hi cuddle")
        let botResponse = dataType.BotText("hey there,Good Morning!!")
        
        let userchat1 = dataType.userText("how is weather today?")
        let botResponse1 = dataType.BotText("Today forecast predicts that the day would be sunny and humid.")
        
        dataArray.append(userchat)
        dataArray.append(botResponse)
        
//        dataArray.append(userchat1)
//        dataArray.append(botResponse1)
        
        if let packetData = createLayoutAndPacketInfo(fromData: "data", layoutFile: "layout") {
            let packetDataType = dataType.packet(packetData)
            dataArray.append(packetDataType)
            
        }
        
        
    }
    
    func createLayoutAndPacketInfo(fromData dataFile:String, layoutFile:String) ->PacketData? {
        var packetObj:PacketData?
        var layoutObj:ViewLayout?
        
        let packetData = FileReader.getFileData(at: dataFile)
        let layoutData = FileReader.getFileData(at: layoutFile)
        do {
            let packetJson = try JSONSerialization.jsonObject(with: packetData!, options: [])
            let layoutJson = try JSONSerialization.jsonObject(with: layoutData!, options: [])
            packetObj = Mapper<PacketData>().map(JSONObject:packetJson)
            layoutObj = Mapper<ViewLayout>().map(JSONObject: layoutJson)

        }catch {
            
        }
        
        packetObj?.layout  = layoutObj
        
        return packetObj
    }
    
    func addData() {
        if let packetData = createLayoutAndPacketInfo(fromData: "data1", layoutFile: "layout1") {
            let packetDataType = dataType.packet(packetData)
            dataArray.append(packetDataType)
        }
    }
    
    func deleteData() {
        dataArray.removeLast()
    }
    
    //assuming the widgets in the packet as Data element.
    func totalCountOfDataElement() ->Int{
        var count = 0
        count = dataArray.count
        
        return count
    }
    
    func dataAtIndex(index:IndexPath) ->dataType {
        return dataArray[index.section]
    }
    
    func dataAt(section:Int) ->dataType {
        return dataArray[section]
    }
    
    func dataEntityCount(atSection section:Int)->Int {
        let data = dataArray[section]
            switch data {
            case .userText(_ ):
                return 1
            case .BotText(_ ):
                return 1
            case .packet(let packet):
                return packet.widgets?.count ?? 0
            }
    }
    
}
