//
//  Database.swift
//  Appy
//
//  Created by Bizet Rodriguez on 10/26/18.
//  Copyright © 2018 Bizet Rodriguez. All rights reserved.
//

import Foundation
import SQLite3

class Database {
    lazy var db: OpaquePointer? = {
        return openDatabase()
    }()
    
    let queryStatementStringUserLogin = "SELECT * FROM User;"
    let insertStatementStringUser = "INSERT INTO User (user_name, user_email, user_password) VALUES (?,?,?);"
    let createTableUserString = """
            CREATE TABLE User(
            user_id                 INTEGER             PRIMARY KEY         AUTOINCREMENT,
            user_name               VARCHAR(255)        NOT NULL,
            user_email              VARCHAR(255)        NOT NULL,
            user_password           VARCHAR(255)        NOT NULL
    );
    """
    
    let insertStatementStringGroup = "INSERT INTO MyGroup (group_name, user_id, user_name, group_color) VALUES (?,?,?,?);"
    let queryStatementStringGroup = "SELECT * FROM MyGroup;"
    let createTableGroupString = """
        CREATE TABLE MyGroup (
        group_id                 INTEGER             PRIMARY KEY         AUTOINCREMENT,
        group_name               VARCHAR(255)        NOT NULL,
        user_id                  VARCHAR(255)        NOT NULL,
        user_name                VARCHAR(255)        NOT NULL,
        group_color              VARCHAR(255)        NOT NULL
    );
    """
    
    
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        
//        guard let part1DbPath = Bundle.main.path(forResource: "Appy", ofType: "sqlite") else {fatalError("Could not find video!")}
        
        let part1DbPath = "/Users/bizetrodriguez/Desktop/Appy/Databases/Appy.sqlite"
        
        if sqlite3_open(String(part1DbPath), &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(String(part1DbPath))")
            return db
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
            return nil
        }
    }
    
    func queryUser(user_name: String, user_password: String) -> Bool {
        var pass = false
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementStringUserLogin, -1, &queryStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol1!)
                let queryResultCol3 = sqlite3_column_text(queryStatement, 3)
                let password = String(cString: queryResultCol3!)
                
                if (user_name == name) && (user_password == password) {
                    pass = true
                }
            }
            
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return pass
    }
    
    func createTableUser() {
        // 1
        var createTableStatement: OpaquePointer? = nil
        // 2
        if sqlite3_prepare_v2(db, createTableUserString, -1, &createTableStatement, nil) == SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("User table created.")
            } else {
                print("User table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }
    
    func insertUser(user_name: String, user_email: String, user_password: String) -> Bool {
        var insertStatement: OpaquePointer? = nil
        var pass = false
        // 1
        if sqlite3_prepare_v2(db, insertStatementStringUser, -1, &insertStatement, nil) == SQLITE_OK {
            //            let id: Int32 = 1
            let name = user_name as NSString
            let email: NSString = user_email as NSString
            let password: NSString = user_password as NSString
            // 2
            //            sqlite3_bind_int(insertStatement, 1, id)
            // 3
            sqlite3_bind_text(insertStatement, 1, name.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, email.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, password.utf8String, -1, nil)
            
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
                pass = true
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
        
        return pass
    }
    
    func createTableGroup() {
        // 1
        var createTableStatement: OpaquePointer? = nil
        // 2
        if sqlite3_prepare_v2(db, createTableGroupString, -1, &createTableStatement, nil) == SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("MyGroup table created.")
            } else {
                print("MyGroup table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }
    
    func insertGroup(group_name: String, user_id: Int32, user_name: String, group_color: String) {
        var insertStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(db, insertStatementStringGroup, -1, &insertStatement, nil) == SQLITE_OK {
            //            let id: Int32 = 1
            let group_name = group_name as NSString
            let user_id: Int32 = user_id
            let user_name: NSString = user_name as NSString
            let group_color: NSString = group_color as NSString
            // 2
            //            sqlite3_bind_int(insertStatement, 1, id)
            // 3
            sqlite3_bind_text(insertStatement, 1, group_name.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 2, user_id)
            sqlite3_bind_text(insertStatement, 3, user_name.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, group_color.utf8String, -1, nil)
            
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    
    func queryGroup() -> [Group] {
        var queryStatement: OpaquePointer? = nil
        var info: [Group] = []
        // 1
        if sqlite3_prepare_v2(db, queryStatementStringGroup, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            //                if sqlite3_step(queryStatement) == SQLITE_ROW {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                //                    let id = sqlite3_column_int(queryStatement, 0)
                
                let name = String(cString: sqlite3_column_text(queryStatement, 1)!)
                let color = String(cString: sqlite3_column_text(queryStatement, 4)!)
                info.append(Group(groupName: name, groupColor: color))
                
                #warning("Make sure only groups associated with certain users appear")
            }
            
            //                } else {
            //                    print("Query returned no results")
            //                }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
        
        return info
    }
    /* Save for later */
    //    let updateStatementString = "UPDATE User SET user_name = 'Chris' WHERE user_id = 1;"
    
    //    let deleteStatementStirng = "DELETE FROM User WHERE user_id = 1;"
    
    //    func update() {
    //        var updateStatement: OpaquePointer? = nil
    //        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
    //            if sqlite3_step(updateStatement) == SQLITE_DONE {
    //                print("Successfully updated row.")
    //            } else {
    //                print("Could not update row.")
    //            }
    //        } else {
    //            print("UPDATE statement could not be prepared")
    //        }
    //        sqlite3_finalize(updateStatement)
    //    }
    
    //    func delete() {
    //        var deleteStatement: OpaquePointer? = nil
    //        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
    //            if sqlite3_step(deleteStatement) == SQLITE_DONE {
    //                print("Successfully deleted row.")
    //            } else {
    //                print("Could not delete row.")
    //            }
    //        } else {
    //            print("DELETE statement could not be prepared")
    //        }
    //
    //        sqlite3_finalize(deleteStatement)
    //    }
}
