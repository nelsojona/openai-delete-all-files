#!/bin/bash

# Pagination parameters
AFTER=""
BEFORE=""
LIMIT=100

# Fetch the list of assistants with pagination
curl -s "https://api.openai.com/v1/assistants?order=desc&limit=$LIMIT&after=$AFTER&before=$BEFORE" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -H "OpenAI-Beta: assistants=v1" > assistant_list.json

# Fetch the list of files
curl -s https://api.openai.com/v1/files \
  -H "Authorization: Bearer $OPENAI_API_KEY" > file_list.json

# Delete assistants and their files
if [ -s assistant_list.json ]; then
    # Extract assistant IDs
    assistant_ids=$(jq -r '.data[].id' assistant_list.json)

    # Loop through each assistant ID
    for id in $assistant_ids; do
        echo "Processing assistant with ID: $id"

        # Fetch and delete assistant files
        assistant_file_list=$(curl -s "https://api.openai.com/v1/assistants/$id/files" \
          -H "Authorization: Bearer $OPENAI_API_KEY" \
          -H "Content-Type: application/json" \
          -H "OpenAI-Beta: assistants=v1")
        
        assistant_file_ids=$(echo $assistant_file_list | jq -r '.data[].id')
        for file_id in $assistant_file_ids; do
            echo "Deleting assistant file with ID: $file_id"
            delete_file_response=$(curl -s -X DELETE "https://api.openai.com/v1/assistants/$id/files/$file_id" \
              -H "Authorization: Bearer $OPENAI_API_KEY" \
              -H "Content-Type: application/json" \
              -H "OpenAI-Beta: assistants=v1")
            
            if [[ $delete_file_response == *"\"deleted\": true"* ]]; then
                echo "Assistant file $file_id deleted successfully."
            else
                echo "Failed to delete assistant file $file_id. Response: $delete_file_response"
            fi
        done

        # Delete the assistant
        echo "Deleting assistant with ID: $id"
        delete_response=$(curl -s -X DELETE https://api.openai.com/v1/assistants/$id \
          -H "Authorization: Bearer $OPENAI_API_KEY" \
          -H "Content-Type: application/json" \
          -H "OpenAI-Beta: assistants=v1")
        
        if [[ $delete_response == *"\"deleted\": true"* ]]; then
            echo "Assistant $id deleted successfully."
        else
            echo "Failed to delete assistant $id. Response: $delete_response"
        fi
    done

    echo "All assistants and their files have been deleted."
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
        
        if [[ $delete_response == *"\"deleted\": true"* ]]; then
            echo "File $id deleted successfully."
        else
            echo "Failed to delete file $id. Response: $delete_response"
        fi
    done

    echo "All standalone files have been deleted."
else
    echo "No standalone files to delete or error retrieving files."
fi
