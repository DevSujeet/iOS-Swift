//
//  layout.swift
//  collectionViewTest
//
//  Created by Sujeet.Kumar on 10/4/17.
//  Copyright © 2017 Fractal. All rights reserved.
//

/*
 {
 "rows": 4,
 "columns": 3,
 "widgets": [
 {
 "row": 0,
 "column": 0,
 "colspan": 3,
 "rowspan": 1
 }, {
 "row": 1,
 "column": 0,
 "colspan": 3,
 "rowspan": 1
 }, {
 "row": 2,
 "column": 0,
 "colspan": 1,
 "rowspan": 1
 }, {
 "row": 2,
 "column": 1,
 "colspan": 1,
 "rowspan": 1
 }, {
 "row": 2,
 "column": 2,
 "colspan": 1,
 "rowspan": 1
 }, {
 "row": 3,
 "column": 0,
 "colspan": 3,
 "rowspan": 1
 }
 ]
 }
 */
/*
    ASSUMPTION is that the row span will always be one. ie a cell should not be part for two rows.
 */
import Foundation
import ObjectMapper

class ViewLayout:NSObject , Mappable {
    var rows:Int = 0    //max possible Row
    var columns:Int = 0 //max possible coloumns
    var widgets:[WidgetLayout]?
    
    var rowInfo:[Int:[Int]]? = [:] //number of rows(val) for indexpath.row(key)
    var indexRowCountInfo: [Int:Int] = [:]
    var numberOfItem:Int?
    
    //MARK:- object Mapper and default initializer methods
    override var description: String {
        return "rows: \(rows), columns: \(columns)"
    }
    
    required init?(map:Map){
        
    }
    
    func mapping(map: Map) {
        rows <- map["rows"]
        columns <- map["columns"]
        widgets <- map["widgets"]
        
        setUpRowInformation()
    }

    func setUpRowInformation() {
        /*
            get number of cell in each row
            the count  of cell in each row equal the number of index mapped as value against row(key)
         */
        
        for (index,widget) in widgets!.enumerated() {
            
            if rowInfo?[widget.row] == nil {
                let indexArray:[Int] = []
                rowInfo?[widget.row] = indexArray
            }
            rowInfo?[widget.row]?.append(index)
        }
        //now get the row count for each index
        for (_,value) in rowInfo! {
            let count = value.count
            for index in value {
                indexRowCountInfo[index] = count
                widgets?[index].cellCountInRow = count
            }
        }
        
    }
}

class WidgetLayout:NSObject , Mappable{
    var row:Int = 0
    var column:Int = 0
    var colspan:Int = 0
    var rowspan:Int = 0
    var templateId:String = ""
    
    var cellCountInRow:Int?
    
    //MARK:- object Mapper and default initializer methods
    override var description: String {
        return "row: \(row), coloumn: \(column),colspan: \(colspan), rowspan: \(rowspan), templateId: \(templateId)"
    }
    
    required init?(map:Map){
        
    }
    
    func mapping(map: Map) {
        row <- map["row"]
        column <- map["column"]
        colspan <- map["colspan"]
        rowspan <- map["rowspan"]
        templateId <- map["templateId"]
    }

}












