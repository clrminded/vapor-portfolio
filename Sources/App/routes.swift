import Vapor
import Fluent



func routes(_ app: Application) throws {
    app.get { req -> EventLoopFuture<View> in
        
        return req.view.render("index", [
                                "title":"Vapor",
                                "name":"Chris",
                                "job":"Programmer"])
    }
    
    app.get("hello", ":name") { req -> String in

        guard let name = req.parameters.get("name") else {
            throw Abort(.internalServerError)
        }
        return "Hello, \(name)!"
    }
    
    app.post("hello") { req -> String in
        let data = try req.content.decode(InfoData.self)
        return "Hello \(data.name)!"
    }
    
    
    // Create
    app.post("api", "acronyms") { req -> EventLoopFuture<Acronym> in
      let acronym = try req.content.decode(Acronym.self)

      return acronym.save(on: req.db).map { acronym }
    }
    
    // Read all
    app.get("api", "acronyms") {
        req -> EventLoopFuture<[Acronym]> in
        Acronym.query(on: req.db).all()
    }
    // Read single
    app.get("api","acronyms", ":acronymID") {
        req -> EventLoopFuture<Acronym> in
        Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    // Update
    app.put("api", "acronyms", ":acronymID") {
        req -> EventLoopFuture<Acronym> in
        let updatedAcronym = try req.content.decode(Acronym.self)
        return Acronym.find(
            req.parameters.get("acronymID"),
            on: req.db)
            .unwrap(or: Abort(.notFound)).flatMap { acronym in
                acronym.short = updatedAcronym.short
                acronym.long = updatedAcronym.long
                return acronym.save(on: req.db).map {
                    acronym
                }
            }
    }
    
    // Delete
    app.delete("api", "acronyms", ":acronymID") {
        req -> EventLoopFuture<HTTPStatus> in
        Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { acronym in
                acronym.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
    
    // filter
    app.get("api", "acronyms", "search") {
      req -> EventLoopFuture<[Acronym]> in
      // 2
      guard let searchTerm =
        req.query[String.self, at: "term"] else {
        throw Abort(.badRequest)
      }
    // 3
        return Acronym.query(on: req.db).group(.or) { or in
          // 2
          or.filter(\.$short == searchTerm)
          // 3
          or.filter(\.$long == searchTerm)
        // 4
        }.all()
    }
    
    // Get First
    app.get("api", "acronyms", "first") {
      req -> EventLoopFuture<Acronym> in
      // 2
      Acronym.query(on: req.db)
        .first()
        .unwrap(or: Abort(.notFound))
    }
    
    // sorting
    app.get("api", "acronyms", "sorted") {
      req -> EventLoopFuture<[Acronym]> in
      // 2
      Acronym.query(on: req.db)
        .sort(\.$short, .ascending)
        .all()
        
    }
    

}

struct InfoData:Content {
    let name: String
}
