# Search Encrypted Email

A tool to search for messages in your Thunderbird emails, including GPG encrypted ones.

# Description

Thunderbird does not support search in encrypted emails: https://bugzilla.mozilla.org/show_bug.cgi?id=188988

This script is an attempt to allow search anyway by:
* fetching all messages from Thunderbird's database.
* decrypting messages on the fly using GPG tools.
* displaying messages that match the query.

## Dangerous to use
There are reasons why this is a bad idea and you should not use this script:
* all messages will be decrypted and stored in-memory which could potentially mean they end up written to disk in a cache somewhere.
* this method is very inefficient as every message in the database is searched and decrypted.
* Using the original sqlite file could corrupt it (don't think it will but still).

## Limitations
* In its current state this is just a quick hack for my own purpose.
* It only supports Thunderbird.
* It can only do simple searches (currently it does case insensitive must-match-all search).
* It is assumed the global-messages-db.sqlite is in the root directory of this
  script. It should be able to be more clever to find where the original
  Thunderbird database file is.
* It should be packaged up as a ruby gem with an executable.

## Install
* git clone the project
* copy your global-messages-db.sqlite to the project root (mine for example lives
  at ~/Library/Thunderbird/Profiles/a6vm5p5t.default/global-messages-db.sqlite)

## Usage
Assuming you have ruby installed with the bundler gem:
* cd to project root
* run `bundle exec ./bin/search-encrypted-email search "terms go" here`
* messages will be printed on stdout that have all words (search, "terms go" and here)
* search is case insensitive

Use of this script is at your own risk.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tomtt/search-encrypted-email.
