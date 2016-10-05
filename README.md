# CodeBrawl

**Yet another programming contest platform.**

This time, in Elixir!
Requires Elixir 1.3 and postgresql. Run it with:

```sh
mix deps.get
mix deps.compile
mix run --no-halt
```

Contains three apps.

## Arena

Server that listen to connections, sends challenges to contestants, and judges if it is a valid submission.

## Scoreboard

Web application to present results from the Arena.

## History

Dependency to save or fetch results of matches into or from database.
