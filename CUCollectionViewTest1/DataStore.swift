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
    case widget(WidgetData)
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
        
        dataArray.append(userchat1)
        dataArray.append(botResponse1)
        
        if let packetData = createLayoutAndPacketInfo(fromData: "data", layoutFile: "layout") {
            
            for widget in packetData.widgets! {
                let widgetDataType = dataType.widget(widget)
                dataArray.append(widgetDataType)
            }
            
        }
        
        if let packetData = createLayoutAndPacketInfo(fromData: "data1", layoutFile: "layout1") {
            
            for widget in packetData.widgets! {
                let widgetDataType = dataType.widget(widget)
                dataArray.append(widgetDataType)
            }
            
        }
    }
    
    func createLayoutAndPacketInfo(fromData dataFile:String, layoutFile:String) ->PacketData? {
        var widgetObj:PacketData?
        var layoutObj:ViewLayout?
        
        let widgetData = FileReader.getFileData(at: dataFile)
        let layoutData = FileReader.getFileData(at: layoutFile)
        do {
            let widgetJson = try JSONSerialization.jsonObject(with: widgetData!, options: [])
            let layoutJson = try JSONSerialization.jsonObject(with: layoutData!, options: [])
            widgetObj = Mapper<PacketData>().map(JSONObject:widgetJson)
            layoutObj = Mapper<ViewLayout>().map(JSONObject: layoutJson)
            
//            print("widgetObj = \(widgetObj)")
//            print("layoutObj = \(layoutObj)")
        }catch {
            
        }
        
        widgetObj?.layout  = layoutObj
        
        return widgetObj
    }
    
    
    //assuming the widgets in the packet as Data element.
    func totalCountOfDataElement() ->Int{
        var count = 0
        count = dataArray.count
        
        return count
    }
    
    func dataAtIndex(index:IndexPath) ->dataType {
        return dataArray[index.row]
    }
    
}
