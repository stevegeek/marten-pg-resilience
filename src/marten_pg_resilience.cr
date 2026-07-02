require "pg"

# marten-pg-resilience — crystal-pg resilience patches for Marten apps on
# networked PostgreSQL. Currently: retry idle-killed TLS connections
# (OpenSSL::SSL::Error) instead of surfacing a 500. Production-proven on the
# Writebook Marten deploy (see deploy notes). Remove once crystal-pg
# upstreams the fix.
module MartenPgResilience
  VERSION = "0.1.0"
end

require "./marten_pg_resilience/pg_ssl_connection_lost_patch"
