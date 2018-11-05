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
    
    /*  USER QUERIES  */
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
    
    /*  GROUP QUERIES                   */
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
    
    /*  CATEGORY QUERIES                */
    // Create Table Category
    let createTableCategoryString = """
        CREATE TABLE Category (
            category_id                 INTEGER             PRIMARY KEY         AUTOINCREMENT,
            category_name               VARCHAR(255)        NOT NULL,
            category_color              VARCHAR(255)        NOT NULL,
            group_id                    INTEGER             NOT NULL
        );
    """
    // Insert into Category Table
    let insertStatementStringCategory = "INSERT INTO Category (category_name, category_color, group_id) VALUES(?,?,?);"
    // Query from Category
    let queryStatementStringCategory = "SELECT * FROM Category;"
    
    
    /*  ITEM QUERIES                    */
    // Create Table Item
    let createTableItemString = """
        CREATE TABLE Item (
            item_id                 INTEGER             PRIMARY KEY         AUTOINCREMENT,
            item_name               VARCHAR(255)        NOT NULL,
            item_color              VARCHAR(255)        NOT NULL,
            item_done               INTEGER             NOT NULL,
            category_id             INTEGER             NOT NULL
        );
    """
    let insertStatementStringItem = "INSERT INTO Item (item_name, item_color, item_done, category_id) VALUES(?,?,?,?);"
    // Query from Category
    let queryStatementStringItem = "SELECT * FROM Item;"
    
    /*  CHAT QUERIES                    */
    let createTableChatString = """
        CREATE TABLE Chat (
            chat_id                 INTEGER             PRIMARY KEY         AUTOINCREMENT,
            chat_name               VARCHAR(255)        NOT NULL,
            user_id                 INTEGER             NOT NULL,
            category_id             INTEGER             NOT NULL,
            group_id                INTEGER             NOT NULL
        );
    """
    
    /*  MESSAGE QUERIES                 */
    let createTableMessageString = """
        CREATE TABLE Message (
            message_id              INTEGER             PRIMARY KEY         AUTOINCREMENT,
            message_name            VARCHAR(255)        NOT NULL,
            user_id                 INTEGER             NOT NULL,
            chat_id                 INTEGER             NOT NULL,
            message_time            DATE                NOT NULL
        );
    """
    
    
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        
//        guard let part1DbPath = Bundle.main.path(forResource: "Appy", ofType: "sqlite") else {fatalError("Could not find database!")}
        
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
    
    func createTableCategory() {
        // 1
        var createTableStatement: OpaquePointer? = nil
        // 2
        if sqlite3_prepare_v2(db, createTableCategoryString, -1, &createTableStatement, nil) == SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Category table created.")
            } else {
                print("Category table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared for Category.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }
    
    func insertCategory(category_name: String, category_color: String, group_id: Int32) {
        var insertStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(db, insertStatementStringCategory, -1, &insertStatement, nil) == SQLITE_OK {
            //            let id: Int32 = 1
            let category_name = category_name as NSString
            let category_color: NSString = category_color as NSString
            let group_id: Int32 = group_id
            // 2
            //            sqlite3_bind_int(insertStatement, 1, id)
            // 3
            sqlite3_bind_text(insertStatement, 1, category_name.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, category_color.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, group_id)
            
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
    
    func queryCategory() -> [Category] {
        var queryStatement: OpaquePointer? = nil
        var info: [Category] = []
        // 1
        if sqlite3_prepare_v2(db, queryStatementStringCategory, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            //                if sqlite3_step(queryStatement) == SQLITE_ROW {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                //                    let id = sqlite3_column_int(queryStatement, 0)
                
                let name = String(cString: sqlite3_column_text(queryStatement, 1)!)
                let color = String(cString: sqlite3_column_text(queryStatement, 2)!)
                info.append(Category(name: name, color: color))
                
                #warning("Make sure only categories associated with certain users appear")
            }
            
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
        
        return info
    }
    
    func createTableItem() {
        // 1
        var createTableStatement: OpaquePointer? = nil
        // 2
        if sqlite3_prepare_v2(db, createTableItemString, -1, &createTableStatement, nil) == SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Item table created.")
            } else {
                print("Item table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared for Item.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }
    
    func insertItem(item_name: String, item_color: String, item_done: Int32, category_id: Int32) {
        var insertStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(db, insertStatementStringItem, -1, &insertStatement, nil) == SQLITE_OK {
            //            let id: Int32 = 1
            let item_name = item_name as NSString
            let item_color: NSString = item_color as NSString
            let item_done: Int32 = item_done
            let category_id: Int32 = category_id
            // 2
            //            sqlite3_bind_int(insertStatement, 1, id)
            // 3
            sqlite3_bind_text(insertStatement, 1, item_name.utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, item_color.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, item_done)
            sqlite3_bind_int(insertStatement, 4, category_id)
            
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
    
    func queryItem() -> [Item] {
        var queryStatement: OpaquePointer? = nil
        var info: [Item] = []
        // 1
        if sqlite3_prepare_v2(db, queryStatementStringItem, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            //                if sqlite3_step(queryStatement) == SQLITE_ROW {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                //                    let id = sqlite3_column_int(queryStatement, 0)
                
                let name = String(cString: sqlite3_column_text(queryStatement, 1)!)
                let color = String(cString: sqlite3_column_text(queryStatement, 2)!)
                let done = Int32(sqlite3_column_int(queryStatement, 3))
                info.append(Item(name: name, color: color, done: done))
                
                #warning("Make sure only categories associated with certain users appear")
            }
            
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
