Migration
=========

Manages blocks of code that need to run once on version updates in iOS apps. This could be anything from data
normalization to bug fixes.

This is a drop-in replacement of [MTMigration](https://github.com/mysterioustrousers/MTMigration)'s basic functionality as a Swift package. If you were using MTMigration's `migrateToVersion` functionality, you can use this Swift package instead. Note: This is not a complete replacement as it is missing MTMigration's `applicationUpdateBlock` and `migrateToBuild` functionality, which I have never needed. 

## Installation

Using Xcode, add a package dependency with URL ""https://github.com/Clafou/Migration.git"

## Usage

Call `migrateToVersion` with a version number and a block, and Migration will
ensure that the block of code is only ever run once for that version.

```swift
Migration.migrateToVersion("1.1") {
    // Your migration code here
}
```

You would want to run this code in your app delegate or similar.

Because Migration inspects your *-info.plist file for your actual version number and keeps track of the last migration,
it will migrate all un-migrated blocks in-between. For example, let's say you had the following migrations:

```swift
Migration.migrateToVersion("0.9") {
    // Some 0.9 stuff
}

Migration.migrateToVersion("1.0") {
    // Some 1.0 stuff
}
```

If a user was at version `0.8`, skipped `0.9`, and upgraded to `1.0`, then both the `0.9` *and* `1.0` blocks would run.

For debugging/testing purposes, you can call `reset` to clear out the last recorded migration, causing all
migrations to run from the beginning:

```swift
Migration.reset()
```

## Notes

Migration assumes version numbers are incremented in a logical way, i.e. `1.0.1` -> `1.0.2`, `1.1` -> `1.2`, etc.

Version numbers that are past the version specified in your app will not be run. For example, if your *-info.plist file
specifies `1.2` as the app's version number, and you attempt to migrate to `1.3`, the migration will not run.

Blocks are executed on the thread the migration is run on. Background/foreground situations should be considered accordingly.

## Contributing

This library does not handle some more intricate migration situations, if you come across intricate use cases from your own
app, please add it and submit a pull request. Be sure to add test cases.

## Contributors

MTMigration:
- [Parker Wightman](https://github.com/pwightman) ([@parkerwightman](http://twitter.com/parkerwightman))
- [Good Samaritans](https://github.com/mysterioustrousers/MTMigration/contributors)
- [Hector Zarate](https://github.com/Hecktorzr)
- [Sandro Meier](https://github.com/fechu)
- [Seb Molines](https://github.com/clafou)
