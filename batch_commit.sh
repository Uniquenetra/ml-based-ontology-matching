#!/bin/bash

# Function to stage, commit, and push files in batches
stage_commit_push() {
    BATCH_SIZE=$1
    FILES=($2)
    TOTAL_FILES=${#FILES[@]}
    START=0

    # Create and switch to a new branch
    git checkout -b feature-branch

    while [ $START -lt $TOTAL_FILES ]; do
        END=$(($START + $BATCH_SIZE))
        if [ $END -gt $TOTAL_FILES ]; then
            END=$TOTAL_FILES
        fi

        BATCH_FILES=(${FILES[@]:$START:$BATCH_SIZE})

        # Stage the batch files
        git add ${BATCH_FILES[@]}

        # Commit the batch files
        git commit -m "Add batch of files from $START to $END"

        START=$END
    done

    # Push the new branch
    git push origin feature-branch

    # Instructions to create a PR
    echo "Now create a PR from 'feature-branch' to 'main' on GitHub."
}

# List of files to be committed
FILES=($(git ls-files -o --exclude-standard))

# Define the batch size
BATCH_SIZE=10

# Call the function with batch size and list of files
stage_commit_push $BATCH_SIZE "${FILES[@]}"

