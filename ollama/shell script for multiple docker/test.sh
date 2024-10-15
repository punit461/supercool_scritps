#!/bin/bash
# test.sh - to make request to a given  number of llama2 instances

rm file.txt && echo "file.txt cleare"

# Define the command to be executed
curl_command="curl --location 'http://0.0.0.0:8000/chat/completions' --header 'Content-Type: application/json' --data ' {
  \"model\": \"phi3\",
  \"messages\": [
    {
      \"role\": \"user\",
      \"content\": \"tell a long story about unicorns\"
    }
  ]
}' | jq .choices[0].message.content  >> file.txt"

# Run the command n times in parallel
for i in {1..3}; do
    eval "$curl_command" && echo "Command $i succeeded." &  # Run the command in the background
done

# Wait for all background processes to finish
wait

echo "All commands completed."