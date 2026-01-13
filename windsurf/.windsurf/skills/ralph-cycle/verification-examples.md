# Verification Command Examples

Common verification patterns for different tech stacks.

## JavaScript/TypeScript

### Node.js + Jest
```bash
npm test
npm run test:coverage
```

### Node.js + Mocha
```bash
npm test
npm run test:unit
```

### Linting
```bash
npm run lint
eslint .
```

## Python

### pytest
```bash
pytest
pytest --cov=src tests/
python -m pytest -v
```

### unittest
```bash
python -m unittest discover
python -m unittest tests/test_*.py
```

### Linting
```bash
pylint src/
flake8 .
black --check .
```

## Go

### Testing
```bash
go test ./...
go test -v ./...
go test -cover ./...
```

### Linting
```bash
golint ./...
go vet ./...
```

## Rust

### Testing
```bash
cargo test
cargo test --verbose
```

### Linting
```bash
cargo clippy
cargo fmt --check
```

## Ruby

### RSpec
```bash
bundle exec rspec
rspec spec/
```

### Minitest
```bash
rake test
ruby -Itest test/test_*.rb
```

## Java

### Maven
```bash
mvn test
mvn verify
```

### Gradle
```bash
gradle test
./gradlew test
```

## Build Verification

Many projects require a successful build before tests:

```bash
# Node.js
npm run build

# Python
python setup.py build

# Go
go build ./...

# Rust
cargo build

# Java (Maven)
mvn compile
```

## Tips

1. **Check package.json or equivalent** for project-specific test scripts
2. **Run tests from project root** unless otherwise specified
3. **Ensure dependencies are installed** before running tests
4. **Check CI configuration** (`.github/workflows`, `.gitlab-ci.yml`) for official verification commands
