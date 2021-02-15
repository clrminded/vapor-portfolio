import Fluent
// 1
struct CreateAcronym: Migration {
  // 2
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    // 3
    database.schema("acronyms")
      .id()
      .field("short", .string, .required)
      .field("long", .string, .required)
      .create()
}
// 7
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("acronyms").delete()
  }
}
