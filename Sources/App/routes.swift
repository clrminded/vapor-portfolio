import Vapor



func routes(_ app: Application) throws {
    app.get { req -> EventLoopFuture<View> in
        
        return req.view.render("index", [
                                "title":"Vapor",
                                "name":"Chris",
                                "job":"Programmer"])
    }
    
    app.get("hello") { req -> EventLoopFuture<View> in

        struct HelloContext: Encodable {
            var title:String
            var name:String
        }
        return req.view.render("hello", HelloContext(title:"Vapor", name: "Julianna"))
    }
}
