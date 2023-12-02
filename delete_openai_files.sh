#!/bin/bash

# Fetch the list of assistants
curl -s "https://api.openai.com/v1/assistants?order=desc&limit=20" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -H "OpenAI-Beta: assistants=v1" > assistant_list.json

# Fetch the list of files
curl -s https://api.openai.com/v1/files \
  -H "Authorization: Bearer $OPENAI_API_KEY" > file_list.json

# Delete assistants
if [ -s assistant_list.json ]; then
    # Extract assistant IDs
    assistant_ids=$(jq -r '.data[].id' assistant_list.json)

    # Loop through each assistant ID and delete the assistant
    for id in $assistant_ids; do
        echo "Deleting assistant with ID: $id"
        delete_response=$(curl -s -X DELETE https://api.openai.com/v1/assistants/$id \
          -H "Authorization: Bearer $OPENAI_API_KEY" \
          -H "Content-Type: application/json" \
          -H "OpenAI-Beta: assistants=v1")
        
        # Check if the assistant was successfully deleted
        if [[ $delete_response == *"\"deleted\": true"* ]]; then
            echo "Assistant $id deleted successfully."
        else
            echo "Failed to delete assistant $id. Response: $delete_response"
        fi
    done

    echo "All assistants have been deleted."
else
    echo "No assistants to delete or error retrieving assistants."
fi

# Delete files
if [ -s file_list.json ]; then
    # Extract file IDs
    file_ids=$(jq -r '.data[].id' file_list.json)

    # Loop through each file ID and delete the file
    for id in $file_ids; do
        echo "Deleting file with ID: $id"
        delete_response=$(curl -s -X DELETE https://api.openai.com/v1/files/$id \
          -H "Authorization: Bearer $OPENAI_API_KEY")
        
        # Check if the file was successfully deleted
        if [[ $delete_response == *"\"deleted\": true"* ]]; then
            echo "File $id deleted successfully."
        else
            echo "Failed to delete file $id. Response: $delete_response"
        fi
    done

    echo "All files have been deleted."
else
    echo "No files to delete or error retrieving files."
fi
