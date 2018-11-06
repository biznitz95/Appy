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
    
    func foo(name: String?) -> String {
        struct Holder {
            static var user_name = ""
        }
        if let _ = name {
            Holder.user_name = name!
        }
        return Holder.user_name
    }
    
    /*  USER QUERIES  */
    let createTableUserString = """
            CREATE TABLE User(
            user_id                 INTEGER             PRIMARY KEY         AUTOINCREMENT,
            user_name               VARCHAR(255)        NOT NULL,
            user_email              VARCHAR(255)        NOT NULL,
            user_password           VARCHAR(255)        NOT NULL
    );
    """
    let createTableGroupString = """
        CREATE TABLE IF NOT EXISTS MyGroup (
        group_id                 INTEGER             PRIMARY KEY         AUTOINCREMENT,
        group_name               VARCHAR(255)        NOT NULL,
        user_id                  INTEGER             NOT NULL,
        user_name                VARCHAR(255)        NOT NULL,
        group_color              VARCHAR(255)        NOT NULL
    );
    """
    let createTableCategoryString = """
        CREATE TABLE IF NOT EXISTS Category (
            category_id                 INTEGER             PRIMARY KEY         AUTOINCREMENT,
            category_name               VARCHAR(255)        NOT NULL,
            category_color              VARCHAR(255)        NOT NULL,
            group_id                    INTEGER             NOT NULL
        );
    """
    let createTableItemString = """
        CREATE TABLE Item (
            item_id                 INTEGER             PRIMARY KEY         AUTOINCREMENT,
            item_name               VARCHAR(255)        NOT NULL,
            item_color              VARCHAR(255)        NOT NULL,
            item_done               INTEGER             NOT NULL,
            category_id             INTEGER             NOT NULL
        );
    """
    let createTableChatString = """
        CREATE TABLE Chat (
            chat_id                 INTEGER             PRIMARY KEY         AUTOINCREMENT,
            chat_name               VARCHAR(255)        NOT NULL,
            user_id                 INTEGER             NOT NULL,
            category_id             INTEGER             NOT NULL,
            group_id                INTEGER             NOT NULL
        );
    """
    let createTableMessageString = """
        CREATE TABLE Message (
            message_id              INTEGER             PRIMARY KEY         AUTOINCREMENT,
            message_name            VARCHAR(255)        NOT NULL,
            user_id                 INTEGER             NOT NULL,
            chat_id                 INTEGER             NOT NULL,
            message_time            DATE                NOT NULL
        );
    """
    
    /*  USER QUERIES  */
    let queryStatementStringUserLogin = "SELECT * FROM User;"
    let insertStatementStringUser = "INSERT INTO User (user_name, user_email, user_password) VALUES (?,?,?);"
    
    /*  GROUP QUERIES                   */
    let insertStatementStringGroup = "INSERT INTO MyGroup (group_name, user_id, user_name, group_color) VALUES (?,?,?,?);"
    let queryStatementStringGroup = "SELECT * FROM MyGroup;"
    
    /*  CATEGORY QUERIES                */
    let insertStatementStringCategory = "INSERT INTO Category (category_name, category_color, group_id) VALUES(?,?,?);"
    let queryStatementStringCategory = "SELECT * FROM Category;"
    
    
    /*  ITEM QUERIES                    */
    let insertStatementStringItem = "INSERT INTO Item (item_name, item_color, item_done, category_id) VALUES(?,?,?,?);"
    let queryStatementStringItem = "SELECT * FROM Item;"
    
    /*  CHAT QUERIES                    */
    let insertStatementStringChat = "INSERT INTO Chat (chat_name, user_id, category_id, group_id) VALUES(?,?,?,?);"
    let queryStatementStringChat = "SELECT * FROM Chat;"
    
    /*  MESSAGE QUERIES                 */
    let insertStatementStringMessage = "INSERT INTO Message (message_name, user_id, chat_id, message_time) VALUES(?,?,?,?);"
    let queryStatementStringMessage = "SELECT * FROM Message;"
    
    
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
    
    func queryUserID(user_name: String) -> Int32? {
        let queryStatementStringUserID = "SELECT user_id FROM User WHERE user_name = '\(user_name)'"
        
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementStringUserID, -1, &queryStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let queryResultCol0 = sqlite3_column_int(queryStatement, 0)
                let id = Int32(queryResultCol0)
                
                print("Found user_id: \(id)")
                return id
            }
            
        } else {
            print("SELECT statement could not be prepared for User")
        }
        sqlite3_finalize(queryStatement)
        print("Could not find id!")
        return nil
    }
    
    func queryUserCheckForDuplicate(user_name: String) -> Bool {
        let queryStatementStringUserCheck = "Select * FROM User WHERE user_name = '\(user_name)'"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementStringUserCheck, -1, &queryStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                
                if let _ = sqlite3_column_text(queryStatement, 0) {
                    print("User already exists")
                    return true
                }
            }
            
        } else {
            print("SELECT statement could not be prepared for User")
        }
        sqlite3_finalize(queryStatement)
        
        print("User does not exist")
        return false
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
    
    func updateUserName(old_name: String, new_name: String) {
        let updateStatementString = "UPDATE User SET user_name = '\(new_name)' WHERE user_name = '\(old_name)';"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row for User.")
            } else {
                print("Could not update row for User.")
            }
        } else {
            print("UPDATE statement could not be prepared for User")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func updateUserPassword(user_name: String, old_password: String, new_password: String) {
        let updateStatementString = "UPDATE User SET user_password = '\(new_password)' WHERE user_name = '\(user_name)' AND user_password = '\(old_password)';"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared for User")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deleteUser(user_id: Int32) {
        let deleteStatementStirng = "DELETE FROM User WHERE user_id = \(user_id);"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared for User")
        }
        
        sqlite3_finalize(deleteStatement)
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
            print("CREATE TABLE statement could not be prepared for Group.")
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
    
    func queryGroupGivenUserID(user_id: Int32) -> [Group] {
        let queryStatementStringGroupGivenUserId = "SELECT * FROM MyGroup WHERE user_id = \(user_id);"
        var queryStatement: OpaquePointer? = nil
        var info: [Group] = []
        // 1
        if sqlite3_prepare_v2(db, queryStatementStringGroupGivenUserId, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            //                if sqlite3_step(queryStatement) == SQLITE_ROW {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                //                    let id = sqlite3_column_int(queryStatement, 0)
                
                let name = String(cString: sqlite3_column_text(queryStatement, 1)!)
                let color = String(cString: sqlite3_column_text(queryStatement, 4)!)
                info.append(Group(groupName: name, groupColor: color))
                
                #warning("Make sure only groups associated with certain users appear")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
        
        return info
    }
    
    func queryGroupID(group_name: String, user_id: Int32) -> Int32? {
        let queryStatementStringGroupID = "SELECT group_id FROM MyGroup WHERE user_id = \(user_id) AND group_name = '\(group_name)'"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementStringGroupID, -1, &queryStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let queryResultCol0 = sqlite3_column_int(queryStatement, 0)
                let id = Int32(queryResultCol0)
                
                print("Found id: \(id)")
                return id
            }
            
        } else {
            print("SELECT statement could not be prepared for Group")
        }
        sqlite3_finalize(queryStatement)
        print("Could not find id!")
        return nil
    }
    
    func updateGroupName(group_name: String, group_id: Int32) {
        let updateStatementString = "UPDATE MyGroup SET group_name = '\(group_name)' WHERE group_id = \(group_id);"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared for Group")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deleteGroup(group_id: Int32) {
        let deleteStatementStirng = "DELETE FROM MyGroup WHERE group_id = \(group_id);"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared for User")
        }
        
        sqlite3_finalize(deleteStatement)
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
                
            }
            
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
        
        return info
    }
    
    func queryCategoryGiveGroupID(group_id: Int32) -> [Category] {
        var queryStatement: OpaquePointer? = nil
        let queryStatementStringCategoryGivenID = "SELECT * FROM Category WHERE group_id = \(group_id);"
        
        var info: [Category] = []
        // 1
        if sqlite3_prepare_v2(db, queryStatementStringCategoryGivenID, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            //                if sqlite3_step(queryStatement) == SQLITE_ROW {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                //                    let id = sqlite3_column_int(queryStatement, 0)
                
                let name = String(cString: sqlite3_column_text(queryStatement, 1)!)
                let color = String(cString: sqlite3_column_text(queryStatement, 2)!)
                info.append(Category(name: name, color: color))
                
            }
            
        } else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
        
        return info
    }
    
    func queryCategoryID(category_name: String, group_id: Int32) -> Int32? {
        let queryStatementStringCategoryID = "SELECT category_id FROM Category WHERE category_name = '\(category_name)' AND group_id = \(group_id)"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementStringCategoryID, -1, &queryStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let queryResultCol0 = sqlite3_column_int(queryStatement, 0)
                let id = Int32(queryResultCol0)
                
                print("Found id: \(id)")
                return id
            }
            
        } else {
            print("SELECT statement could not be prepared for Group")
        }
        sqlite3_finalize(queryStatement)
        print("Could not find id!")
        return nil
    }
    
    func updateCategory(category_name: String, category_id: Int32) {
        let updateStatementString = "UPDATE Category SET category_name = '\(category_name)' WHERE category_id = \(category_id);"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared for Category")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deleteCategory(category_id: Int32) {
        let deleteStatementStirng = "DELETE FROM Category WHERE category_id = \(category_id);"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared for Category")
        }
        
        sqlite3_finalize(deleteStatement)
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

    func queryItemID(item_name: String, category_id: Int32) -> Int32? {
        let queryStatementStringItemID = "SELECT item_id FROM Item WHERE item_name = '\(item_name)' AND category_id = \(category_id)"
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementStringItemID, -1, &queryStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let queryResultCol0 = sqlite3_column_int(queryStatement, 0)
                let id = Int32(queryResultCol0)
                
                print("Found id: \(id)")
                return id
            }
            
        } else {
            print("SELECT statement could not be prepared for Item")
        }
        sqlite3_finalize(queryStatement)
        print("Could not find id!")
        return nil
    }
    
    func updateItem(item_name: String, item_id: Int32) {
        let updateStatementString = "UPDATE Item SET item_name = '\(item_name)' WHERE item_id = \(item_id);"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared for Item")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deleteItem(item_id: Int32) {
        let deleteStatementStirng = "DELETE FROM Item WHERE item_id = \(item_id);"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared for Item")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    func createTableChat() {
        // 1
        var createTableStatement: OpaquePointer? = nil
        // 2
        if sqlite3_prepare_v2(db, createTableChatString, -1, &createTableStatement, nil) == SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Chat table created.")
            } else {
                print("Chat table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared for Chat.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }
    
    func insertChat(chat_name: String, user_id: Int32, category_id: Int32, group_id: Int32) {
        var insertStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(db, insertStatementStringChat, -1, &insertStatement, nil) == SQLITE_OK {
            
            let chat_name = chat_name as NSString
            let user_id: Int32 = user_id
            let category_id: Int32 = category_id
            let group_id: Int32 = group_id
            
            sqlite3_bind_text(insertStatement, 1, chat_name.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 2, user_id)
            sqlite3_bind_int(insertStatement, 3, category_id)
            sqlite3_bind_int(insertStatement, 4, group_id)
            
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared for Chat.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    
    func queryChat(){ // //"INSERT INTO Item (chat_name, user_id, category_id, group_id)
        var queryStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(db, queryStatementStringChat, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let name = String(cString: sqlite3_column_text(queryStatement, 1)!)
                let user_id = Int32(sqlite3_column_int(queryStatement, 2))
                let category_id = Int32(sqlite3_column_int(queryStatement, 3))
                let group_id = Int32(sqlite3_column_int(queryStatement, 4))
                
                print("Chat Name: \(name)")
                print("User ID: \(user_id)")
                print("Category ID: \(category_id)")
                print("Group ID: \(group_id)")
            }
            
        } else {
            print("SELECT statement could not be prepared for Chat")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
    }
    
    func queryChatID(chat_name: String, user_id: Int32, group_id: Int32, category_id: Int32) -> Int32? {
        let queryStatementStringChatID = "SELECT chat_id FROM Chat WHERE chat_name = '\(chat_name)' AND user_id = \(user_id) AND group_id = \(group_id) AND category_id = \(category_id) "
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementStringChatID, -1, &queryStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let queryResultCol0 = sqlite3_column_int(queryStatement, 0)
                let id = Int32(queryResultCol0)
                
                print("Found id: \(id)")
                return id
            }
            
        } else {
            print("SELECT statement could not be prepared for Chat")
        }
        sqlite3_finalize(queryStatement)
        print("Could not find id!")
        return nil
    }
    
    func updateChat(chat_name: String, chat_id: Int32) {
        let updateStatementString = "UPDATE Chat SET chat_name = '\(chat_name)' WHERE chat_id = \(chat_id);"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared for Chat")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deleteChat(chat_id: Int32) {
        let deleteStatementStirng = "DELETE FROM Chat WHERE chat_id = \(chat_id);"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared for Chat")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    func createTableMessage() {
        // 1
        var createTableStatement: OpaquePointer? = nil
        // 2
        if sqlite3_prepare_v2(db, createTableMessageString, -1, &createTableStatement, nil) == SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Message table created.")
            } else {
                print("Message table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared for Message.")
        }
        // 4
        sqlite3_finalize(createTableStatement)
    }
    
    func insertMessage(message_name: String, user_id: Int32, chat_id: Int32, message_time: Double) {
        var insertStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(db, insertStatementStringMessage, -1, &insertStatement, nil) == SQLITE_OK {
            
            let message_name = message_name as NSString
            let user_id: Int32 = user_id
            let chat_id: Int32 = chat_id
            let message_time: Double = message_time
            
            sqlite3_bind_text(insertStatement, 1, message_name.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 2, user_id)
            sqlite3_bind_int(insertStatement, 3, chat_id)
            sqlite3_bind_double(insertStatement, 4, message_time)
            
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared for Message.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    
    func queryMessage(){
        var queryStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(db, queryStatementStringMessage, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let name = String(cString: sqlite3_column_text(queryStatement, 1)!)
                let user_id = Int32(sqlite3_column_int(queryStatement, 2))
                let chat_id = Int32(sqlite3_column_int(queryStatement, 3))
                let time = Double(sqlite3_column_double(queryStatement, 4))
                
                print("Message Name: \(name)")
                print("User ID: \(user_id)")
                print("Chat ID: \(chat_id)")
                print("Time: \(NSDate(timeIntervalSince1970: time))")
            }
            
        } else {
            print("SELECT statement could not be prepared for Message.")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
    }
    
    func queryMessageID(message_name: String, user_id: Int32, chat_id: Int32) -> Int32? {
        let queryStatementStringMessageID = "SELECT message_id FROM Message WHERE message_name = '\(message_name)' AND user_id = \(user_id) AND chat_id = \(chat_id) "
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryStatementStringMessageID, -1, &queryStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let queryResultCol0 = sqlite3_column_int(queryStatement, 0)
                let id = Int32(queryResultCol0)
                
                print("Found id: \(id)")
                return id
            }
            
        } else {
            print("SELECT statement could not be prepared for Message")
        }
        sqlite3_finalize(queryStatement)
        print("Could not find id!")
        return nil
    }
    
    func updateMessage(message_name: String, message_id: Int32) {
        let updateStatementString = "UPDATE Message SET message_name = '\(message_name)' WHERE message_id = \(message_id);"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared for Message")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deleteMessage(message_id: Int32) {
        let deleteStatementStirng = "DELETE FROM Message WHERE message_id = \(message_id);"
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared for Message")
        }
        
        sqlite3_finalize(deleteStatement)
    }
    
    func close() {
        sqlite3_close(db)
        print("Closing database Appy.sqlite")
    }
    
    deinit {
        close()
    }
}

