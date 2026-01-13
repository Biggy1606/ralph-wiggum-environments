# Architecture Examples

Sample functional group breakdowns for different project types.

## Web Application (Full Stack)

```json
["Authentication", "Database", "API", "Frontend", "Testing", "Deployment"]
```

**Rationale:**
- Authentication: User auth, sessions, permissions
- Database: Schema, migrations, ORM setup
- API: REST/GraphQL endpoints, middleware
- Frontend: UI components, state management
- Testing: Unit, integration, e2e tests
- Deployment: CI/CD, hosting, monitoring

## Mobile App

```json
["Auth", "UI-Components", "State-Management", "API-Integration", "Storage", "DevOps"]
```

**Rationale:**
- Auth: Login, registration, token management
- UI-Components: Screens, navigation, reusable components
- State-Management: Redux/MobX/Context setup
- API-Integration: Network layer, data fetching
- Storage: Local database, caching
- DevOps: Build pipeline, app distribution

## CLI Tool

```json
["Core-CLI", "Commands", "Config", "Output", "Testing", "Distribution"]
```

**Rationale:**
- Core-CLI: Argument parsing, command routing
- Commands: Individual command implementations
- Config: Configuration file handling
- Output: Formatting, logging, colors
- Testing: Command tests, integration tests
- Distribution: Packaging, installation

## API Service

```json
["API-Routes", "Database", "Auth", "Business-Logic", "Testing", "Infrastructure"]
```

**Rationale:**
- API-Routes: Endpoint definitions, routing
- Database: Models, migrations, queries
- Auth: JWT, OAuth, API keys
- Business-Logic: Core service functionality
- Testing: API tests, load tests
- Infrastructure: Docker, logging, monitoring

## Data Pipeline

```json
["Ingestion", "Processing", "Storage", "Validation", "Monitoring", "Orchestration"]
```

**Rationale:**
- Ingestion: Data sources, connectors
- Processing: ETL/ELT logic, transformations
- Storage: Database, data warehouse setup
- Validation: Data quality checks
- Monitoring: Metrics, alerts, dashboards
- Orchestration: Scheduling, workflow management

## E-commerce Platform

```json
["Products", "Cart-Checkout", "Payment", "User-Management", "Admin", "DevOps"]
```

**Rationale:**
- Products: Catalog, search, filtering
- Cart-Checkout: Shopping cart, order flow
- Payment: Payment gateway integration
- User-Management: Accounts, profiles, orders
- Admin: Admin panel, inventory management
- DevOps: Deployment, monitoring, scaling

## Tips for Choosing Groups

1. **Distinct Concerns:** Each group should represent a separate technical domain
2. **Balanced Scope:** Aim for roughly equal complexity across groups
3. **Clear Boundaries:** Minimal overlap between groups
4. **Natural Dependencies:** Some groups will naturally depend on others (e.g., Frontend depends on API)
5. **Include Infrastructure:** Don't forget testing, deployment, monitoring
6. **Business vs Technical:** Mix business features with technical infrastructure
