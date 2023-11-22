#!/bin/bash

# Read from the file
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
