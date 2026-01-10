#!/bin/bash

# Multiline String Tutorial for Bash
# This script demonstrates various methods for handling multiline strings in shell scripting

echo "=== Multiline String Tutorial for Bash ==="
echo

# Method 1: Using Heredoc (Here Document)
echo "1. Heredoc Method:"
echo "-------------------"
cat << 'EOF'
This is a multiline string
created using heredoc.
It can contain:
- Special characters: !@#$%^&*()
- Quotes: "single" and 'double'
- Variables: $HOME (when not quoted)
EOF
echo

# Method 2: Heredoc with variable expansion
echo "2. Heredoc with Variable Expansion:"
echo "-----------------------------------"
username="Ralph"
cat << EOF
Hello $username,
Welcome to multiline strings!
Current directory: $PWD
Date: $(date)
EOF
echo

# Method 3: Using quoted strings with line breaks
echo "3. Quoted String Method:"
echo "------------------------"
multiline="This is a multiline string
using quoted strings.
It preserves line breaks
and can contain variables like $HOME."
echo "$multiline"
echo

# Method 4: Using array and join
echo "4. Array Method:"
echo "-----------------"
lines=("Line 1: First line" "Line 2: Second line" "Line 3: Third line")
multiline_array=$(IFS=$'\n'; echo "${lines[*]}")
echo "$multiline_array"
echo

# Method 5: Using printf
echo "5. Printf Method:"
echo "-----------------"
multiline_printf=$(printf "Line 1: %s\nLine 2: %s\nLine 3: %s\n" "First" "Second" "Third")
echo "$multiline_printf"
echo

# Practical Example 1: Configuration file content
echo "6. Practical Example - Config File:"
echo "-----------------------------------"
config_content=$(cat << 'EOF'
# Application Configuration
server.host=localhost
server.port=8080
database.url=jdbc:mysql://localhost:3306/myapp
database.user=admin
database.password=secret123
EOF
)
echo "$config_content"
echo

# Practical Example 2: Email template
echo "7. Practical Example - Email Template:"
echo "--------------------------------------"
recipient="user@example.com"
subject="Welcome to Our Service"
email_body=$(cat << EOF
Dear User,

Welcome to our amazing service!

Your account details:
- Email: $recipient
- Registration Date: $(date)
- Account Status: Active

Best regards,
The Team
EOF
)
echo "To: $recipient"
echo "Subject: $subject"
echo
echo "$email_body"
echo

# Practical Example 3: JSON data
echo "8. Practical Example - JSON Data:"
echo "-----------------------------------"
json_data=$(cat << 'EOF'
{
    "name": "John Doe",
    "age": 30,
    "city": "New York",
    "hobbies": ["reading", "swimming", "coding"],
    "address": {
        "street": "123 Main St",
        "zip": "10001"
    }
}
EOF
)
echo "$json_data"
echo

# Function example with multiline string
echo "9. Function with Multiline String:"
echo "-----------------------------------"

create_banner() {
    local text="$1"
    local width=50
    
    cat << EOF
+--------------------------------------------------+
| $(printf "%-${width}s" "$text") |
+--------------------------------------------------+
EOF
}

banner=$(create_banner "Welcome to Bash Tutorial")
echo "$banner"
echo

# Reading multiline string from file (simulation)
echo "10. Reading from File (Simulated):"
echo "-----------------------------------"
temp_file="/tmp/multiline_example.txt"
cat > "$temp_file" << 'EOF'
This is content that would typically
be read from a file.
It demonstrates how to handle
multiline file content in bash.
EOF

file_content=$(cat "$temp_file")
echo "$file_content"
echo

# Cleanup
rm -f "$temp_file"

echo "=== Tutorial Complete ==="
echo "Key takeaways:"
echo "- Use heredoc for complex multiline strings"
echo "- Use quoted strings for simple multiline text"
echo "- Choose method based on your specific needs"
echo "- Consider variable expansion requirements"