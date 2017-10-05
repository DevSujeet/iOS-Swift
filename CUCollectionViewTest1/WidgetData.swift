//
//  WidgetData.swift
//  collectionViewTest
//
//  Created by Sujeet.Kumar on 10/4/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

import Foundation
import ObjectMapper
/*
 {
 "url": "./src/data/layout.json",
 "widgets": [{
 "type": "title",
 "text": "This is a title"
 }, {
 "type": "subtitle",
 "text": "This is a sub-title"
 }, {
 "type": "view",
 "data": {
 "sales": "2.19 M",
 "percentageFromPrevDay": 20,
 "percentageFromPrevYear": 30
 }
 }, {
 "type": "view",
 "data": {
 "sales": "5 M",
 "percentageFromPrevDay": 40,
 "percentageFromPrevYear": 45
 }
 }, {
 "type": "view",
 "data": {
 "sales": "1.09 M",
 "percentageFromPrevDay": 15,
 "percentageFromPrevYear": 21
 }
 }, {
 "type": "text",
 "text": "Widget 6 - This is a simple text"
 }]
 }
 */
enum widgetType:String {
    case title
    case subtitle
    case view
    case text

}
class PacketData:NSObject,Mappable {
    var url:String? = ""
    var widgets:[WidgetData]?
    var layout:ViewLayout?{
        didSet{
            setLayoutInformtionToEachWidget()
        }
    }  //should be read from file as soon as the widget data object is created and we know which layout is to be applied.
    
    //MARK:- object Mapper and default initializer methods
    override var description: String {
        return "url: \(url), widgets: \(widgets)"
    }
    
    required init?(map:Map){
        
    }
    
    func mapping(map: Map) {
        url <- map["url"]
        widgets <- map["widgets"]
        setUpLayout()   //to set up the layout info when we have the layout file info.
    }
    
    func setUpLayout() {
        
    }
    
    func setLayoutInformtionToEachWidget() {
        for (index,widget) in (widgets?.enumerated())! {
            widget.widgetLayout = layout?.widgets?[index]
            widget.widgetMaxRow = layout?.rows
            widget.widgetMaxColoumn = layout?.columns
        }
    }

}

class WidgetData:NSObject,Mappable {
    var type:widgetType?
    var height:CGFloat?
    var widgetMaxRow :Int?
    var widgetMaxColoumn:Int?
    var widgetLayout:WidgetLayout?
    //MARK:- object Mapper and default initializer methods
    override var description: String {
        return "widget info type: \(type), height = \(height)"
    }
    
    required init?(map:Map){
        
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        height <- map["height"]
    }
}
