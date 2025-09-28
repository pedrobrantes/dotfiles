#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: cp_progress bash function"

# Build the home-manager configuration to get the generated bashrc
arch=$(uname -m)
config_path=$(nix-build .#brantes-${arch}-linux --no-out-link)
generated_bashrc="$config_path/home-files/.bashrc"

# --- Test Case 1: Copying a file ---
echo "--> Testing case: file"
touch test_file.txt

# We expect rsync to be called, which is mocked to do nothing but allow the echo to proceed
output=$(bash -c "source $generated_bashrc; cp_progress test_file.txt dest_file.txt" 2>&1)

if ! echo "$output" | grep -q "Copying file 'test_file.txt' to 'dest_file.txt'..."; then
    echo "FAIL: Did not find expected output for file copy." >&2
    echo "OUTPUT WAS: $output" >&2
    rm test_file.txt
    exit 1
fi
rm test_file.txt
echo "OK: Correct output for file copy."

# --- Test Case 2: Copying a directory ---
echo "--> Testing case: directory"
mkdir test_dir

output=$(bash -c "source $generated_bashrc; cp_progress test_dir dest_dir" 2>&1)

if ! echo "$output" | grep -q "Copying directory 'test_dir' to 'dest_dir'..."; then
    echo "FAIL: Did not find expected output for directory copy." >&2
    echo "OUTPUT WAS: $output" >&2
    rm -r test_dir
    exit 1
fi
rm -r test_dir
echo "OK: Correct output for directory copy."

# --- Test Case 3: Fallback to original cp ---
echo "--> Testing case: fallback"
touch another_test_file.txt
# Run with insufficient arguments to trigger the fallback
output=$(bash -c "source $generated_bashrc; cp_progress another_test_file.txt" 2>&1)

if echo "$output" | grep -q "Copying file"; then
    echo "FAIL: Found progress bar output when it should have fallen back to cp." >&2
    echo "OUTPUT WAS: $output" >&2
    rm another_test_file.txt
    exit 1
fi
rm another_test_file.txt
echo "OK: Correctly fell back to original cp command."
