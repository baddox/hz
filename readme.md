Log Analysis Challenge
======================

## Usage:

    ruby analyze_log.rb log_filename

## Example output:

```
COUNTERS
========
http://www.heyzap.com/
  Total: 1287
  Uniqs: 451

http://www.heyzap.com/payments/
  Total: 155
  Uniqs: 130

http://www.heyzap.com/payments/get_item/.*
  Total: 258
  Uniqs: 2

Weebly plays
  Total: 35271
  Uniqs: 1997

FUNNELS
========
Publishers front page
  Total: 1287
  Uniqs: 451

  Children:
    new_site
      Total: 89
      Uniqs: 56

      Children:
        get_embed
          Total: 0
          Uniqs: 0

Developer front page
  Total: 1287
  Uniqs: 451

  Children:
    developers
      Total: 82
      Uniqs: 53

      Children:
        new_game
          Total: 13
          Uniqs: 6
        import_games
          Total: 0
          Uniqs: 0
        upload_game_simple
          Total: 0
          Uniqs: 0
```