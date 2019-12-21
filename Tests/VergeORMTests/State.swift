//
//  State.swift
//  VergeORMTests
//
//  Created by muukii on 2019/12/17.
//  Copyright © 2019 muukii. All rights reserved.
//

import Foundation

import VergeORM

struct Book: EntityType, Equatable {
  
  typealias IdentifierType = String
  
  var id: Identifier {
    .init(rawID)
  }
  
  let rawID: String
  let authorID: Author.ID
  var name: String = ""
}

struct Author: EntityType {
  
  typealias IdentifierType = String
  
  var id: Identifier {
    .init(rawID)
  }
    
  let rawID: String
  
  static let anonymous: Author = .init(rawID: "anonymous")
}

struct RootState {
  
  struct Database: DatabaseType {
    
    struct Schema: EntitySchemaType {
      let book = Book.EntityTableKey()
      let author = Author.EntityTableKey()
    }
    
    struct Indexes: IndexesType {
      let allBooks = OrderedIDIndex<Schema, Book>.Key()
      let authorGroupedBook = GroupByIndex<Schema, Author, Book>.Key()
      let bookMiddleware = OrderedIDIndex<Schema, Author>.Key()
    }
    
    var middlewares: [AnyMiddleware<RootState.Database>] {
      [
        AnyMiddleware<RootState.Database>(performAfterUpdates: { (context) in
          let ids = context.author.insertsOrUpdates.all().map { $0.id }
          context.indexes.bookMiddleware.append(contentsOf: ids)
        })
      ]
    }
    
    var _backingStorage: BackingStorage = .init()
  }
  
  var db = Database()
}