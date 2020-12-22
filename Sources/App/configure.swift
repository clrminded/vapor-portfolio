import Leaf
import Vapor
import Fluent
import FluentPostgresDriver



// configures your application
public func configure(_ app: Application) throws {
    
    app.databases.use(.postgres(hostname: "localhost", username: "chris", password: "chrisliuda", database: "portfoliodb"), as: .psql)

    app.migrations.add(CreateAcronym())
    app.logger.logLevel = .debug
    try app.autoMigrate().wait()
    
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.views.use(.leaf)
    // register routes
    try routes(app)
}
