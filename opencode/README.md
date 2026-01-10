# Ralph Wiggum for OpenCode

Ralph Wiggum is an autonomous coding agent that incrementally implements features from a product requirements document (PRD) backlog while maintaining a strictly clean working state. It's designed to work seamlessly with OpenCode models.

## Installation

### Prerequisites

- OpenCode CLI installed
- `jq` command-line JSON processor
- Bash shell (Linux/macOS/WSL)

### Setup

1. Clone or download this repository to your local machine
2. Make the scripts executable:
   ```bash
   chmod +x ralph_init.sh ralph.sh
   ```
3. Verify installation by checking the scripts run without errors:
   ```bash
   ./ralph_init.sh --help
   ```

## Usage

### Getting Started

1. **Initialize Ralph** for a new project or task:
   ```bash
   ./ralph_init.sh "Create a new React project"  # or any other task description
   ```
   
   This will create the necessary configuration files:
   - `prd.json` - Product requirements document with task backlog
   - `RULES.md` - Tech stack and coding conventions
   - `progress.txt` - Project progress log

2. **Run Ralph** to execute tasks autonomously:
   ```bash
   ./ralph.sh                    # Auto-detects remaining tasks
   ./ralph.sh 3                  # Run specific number of iterations
   ./ralph.sh auto               # Auto mode (default)
   ./ralph.sh --dry-run          # Preview without executing
   ```

### Workflow

Ralph follows a 6-step workflow for each task:
1. **Analyze**: Read RULES.md to understand tech stack and conventions
2. **Select**: Find highest-priority task in prd.json that's not completed
3. **Execute**: Implement the required code or fix
4. **Verify**: Run tests or type-checks to ensure it works
5. **Record**: Update prd.json (set "passes": true) and progress.txt
6. **Commit**: Run `git commit --no-gpg-sign -am "Ralph: [Task Description]"`

### Configuration

The default model is set to `opencode/big-pickle` but can be changed in the scripts:
```bash
# In ralph.sh and ralph_init.sh
OPENCODE_MODEL="opencode/your-preferred-model"
```

## Development

### Project Structure

```
.
├── ralph_init.sh    # Initializes project and creates config files
├── ralph.sh         # Main autonomous loop executor
├── prd.json         # Product requirements document (created by init)
├── RULES.md         # Tech stack and conventions (created by init)
├── progress.txt     # Progress tracking log (created by init)
└── README.md        # This documentation
```

### Modifying Ralph

- **Tech Stack Detection**: Edit the scanning logic in `ralph_init.sh` to support new languages/frameworks
- **Workflow Customization**: Modify the prompt template in `ralph.sh` to change the autonomous workflow
- **Model Configuration**: Change `OPENCODE_MODEL` variable in both scripts

### File Formats

**PRD Schema**:
```json
{
    "project_meta": {
        "name": "project_name",
        "version": "version",
        "ralph_type": "opencode",
        "opencode_session_id": "session_id"
    },
    "backlog": [
        {
            "group": "category",
            "feature": "feature_name",
            "description": "detailed_description",
            "acceptance_criteria": ["criterion_1 + testing_method"],
            "passes": false
        }
    ]
}
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with various project types
5. Submit a pull request

### Debugging

Enable debug mode by uncommenting `set -x` at the top of either script to see detailed execution steps.

## License

This project is open source and available under the MIT License.
