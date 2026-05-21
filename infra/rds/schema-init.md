# RDS Schema Initialization

The Java services use Flyway, so the database only needs to exist before the services start.

Flyway creates and owns these schemas:

- `accounts`
- `products`
- `orders`

Each service uses the same database credentials and validates the schema with Hibernate after migrations are applied.
