# OpenAI File and Assistant Deletion Script

This script is designed to delete both files and assistants from your OpenAI account. It first fetches the lists of file and assistant IDs from your account and then uses the OpenAI API to delete each file and assistant.

## Prerequisites

Before running this script, ensure the following prerequisites are met:

1. **jq**: A lightweight and flexible command-line JSON processor.
   - Install with Homebrew: `brew install jq`

2. **curl**: A command-line tool for getting or sending data using URL syntax.
   - Install with Homebrew: `brew install curl`

3. **OpenAI API Key**: Your OpenAI API key should be set as an environment variable.
   - Add the following line to your `.zshrc` file:
     ```bash
     export OPENAI_API_KEY="your-openai-key-goes-here"
     ```

## Script Overview

The script performs the following steps:

1. Retrieves a list of assistants and files from the OpenAI API.
2. Checks if the retrieved lists have content.
3. Extracts assistant and file IDs using `jq`.
4. Loops through each assistant and file ID, sending a DELETE request to the OpenAI API for each.
5. Checks if each deletion (assistant or file) was successful and prints a message accordingly.
6. Informs when all assistants and files have been processed.

## How to Run

1. Ensure the script `delete_openai_assets.sh` is in your working directory.
2. Make sure the script is executable:
   ```bash
   chmod +x delete_openai_assets.sh
3. Run the script:
   ```bash
   ./delete_openai_files.sh
   ```

## Important Notes

- The script assumes that `file_list.json` is formatted correctly with an array of file objects under a `data` key.
- Ensure your API key has the necessary permissions to perform file deletions.
- Use this script responsibly as it will permanently delete files from your OpenAI account.

## Troubleshooting

If you encounter any issues, check the following:

- Is `jq` installed and accessible in your path?
- Is your OpenAI API key correctly set in your `.zshrc` file?
- Are there any network issues preventing access to the OpenAI API?
- Is the `file_list.json` file correctly formatted and in the correct location?

For more help, consult the OpenAI API documentation or contact OpenAI support.
