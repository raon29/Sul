//
//  DBHelper.swift
//  Sul
//
//  Created by misong lee on 04/01/2021.
//  Copyright © 2021 misong lee. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper {
    static let shared = DBHelper()
    
    var db : OpaquePointer?
    
    init(){
        self.db = createDB(path: "sulList.sqlite")
    }
    
    func createDB(path:String) -> OpaquePointer? {
        var db : OpaquePointer? = nil
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path)
            //db 연결, 이미 존재한다면 다시 생성하지 않고 넘어감
            if sqlite3_open(filePath.path, &db) == SQLITE_OK {
                print("[DB] Succesfully create Database path : \(filePath.path)")
                return db
            }
        }
        catch{
            print("[DB] ERROR in CreateDB - \(error.localizedDescription)")
        }
        print("[DB] ERROR in CreateDB - sqlite3_open ")
        return nil
    }
    
    func commitQuery(query:String) -> Bool {
        
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("[DB] Query SuccessFully \(query)")
                return true
            }
            else{
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("[DB] \n Query fail :  \(errorMessage)")
                return false
            }
        }
        else{
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("[DB] \n Query Fail ! :\(errorMessage)")
            return false
        }
        sqlite3_finalize(statement)
    }
    
    func readSULData(query:String) -> [SulVO?] {
                
        var statement : OpaquePointer? = nil
        var sulList:[SulVO?] = []
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            
            while sqlite3_step(statement) == SQLITE_ROW{
                // 읽은 Data 변수에 담기
                let name =  String(cString: sqlite3_column_text(statement, 0))
                let price = sqlite3_column_int(statement, 1)
                let img = sqlite3_column_int(statement, 2)
                // 반환할 리스트에 추가
                sulList.append(SulVO(name: name, price: Int(price), img: Bool(img as NSNumber)))
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("[DB] \n read Data prepare fail! : \(errorMessage)")
        }
        sqlite3_finalize(statement)
        // 결과 리스트 반환
        return sulList
    }
    
}
