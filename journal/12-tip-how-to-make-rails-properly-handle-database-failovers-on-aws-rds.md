# Tip: How to make Rails properly handle database failovers on AWS RDS

Problem: a client had multiple rails apps pointing to a few RDS databases, in multi-AZ mode. However, after initiating a database failover, the apps would appear to be stuck trying to reach the old database master, instead of gracefully killing the stale connection, and reconnecting.

After a few tries and a lot of digging, here is the configuration for Rails' `DATABASE_URL` that appears to work for our multi-AZ **PostgreSQL** RDS instances:

```
DATABASE_URL=postgres://dbuser:dbpassword@rds-dbhost:5432/dbname?pool=5&encoding=unicode&reconnect=true&connect_timeout=2&keepalives_idle=30&keepalives_interval=10&keepalives_count=2&checkout_timeout=5&reaping_frequency=10
```

Or in a `config/database.yml`:

``` yaml
host: rds-dbhost
port: 5432
username: dbuser
password: dbpassword
database: dbname
pool: 5
encoding: unicode
reconnect: true
connect_timeout: 2
keepalives_idle: 30
keepalives_interval: 10
keepalives_count: 2
checkout_timeout: 5
reaping_frequency: 10
```

Note:
- If you're not using `DATABASE_URL`, you can also use the same settings in your `config/database.yml`.
- These settings are quite aggressive and should probably be tuned if your latency to reach your database is somewhat high.
- Some are probably redundant/useless, or plain wrong, so let me know in the comments ;) But at least the failover is now happening in less than a minute.

Relevant documentation:
- https://www.postgresql.org/docs/current/static/libpq-connect.html (from http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/PostgreSQLAdapter.html#method-i-reconnect-21)
- http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/ConnectionPool.html
