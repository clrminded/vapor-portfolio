import Vapor



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
    
    app.post("api", "acronyms") { req -> EventLoopFuture<Acronym> in
      let acronym = try req.content.decode(Acronym.self)

      return acronym.save(on: req.db).map {
        acronym
      }
    }
}

struct InfoData:Content {
    let name: String
}
