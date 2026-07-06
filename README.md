# marten-pg-resilience

A Crystal shard that patches `crystal-pg` to retry idle-killed TLS connections
instead of surfacing a 500 error.

## The problem

`crystal-pg` (as of 0.29.0) only rescues `IO::Error` when re-raising as
`DB::ConnectionLost` so the connection pool can retry on a dead socket. When
PostgreSQL is reached over a TLS connection (managed Postgres, Tailscale, any
firewall that reaps idle connections), a half-closed socket surfaces as
`OpenSSL::SSL::Error` ("SSL_write: Unexpected EOF while reading"), which is
**not** an `IO::Error` — it inherits from `OpenSSL::Error -> Exception`. The
exception bubbles all the way out and the first request after an idle period
500s instead of being transparently retried on a fresh connection.

## The fix

This shard reopens `PG::Statement#perform_query` and `#perform_exec` to also
rescue `OpenSSL::SSL::Error` and raise `DB::ConnectionLost`, enabling the pool
to retry. Production-proven on a Writebook Marten deploy.

**Remove this shard once crystal-pg upstreams the fix.**

## Installation

Add to your `shard.yml`:

```yaml
dependencies:
  marten_pg_resilience:
    github: stevegeek/marten-pg-resilience
```

Then require it **after** your `pg` require (typically in your app entrypoint):

```crystal
require "marten_pg_resilience"
```

No other configuration is needed. The patch is a no-op when not using the
PostgreSQL backend (e.g., SQLite in development/test).

## Provenance

Extracted from a production Writebook Marten port.

## License

MIT
