import os

def find_null_bytes(directory):
    null_files = []
    for root, _, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            try:
                with open(file_path, 'rb') as f:
                    if b'\x00' in f.read():
                        null_files.append(file_path)
            except Exception as e:
                print(f"Error reading {file_path}: {e}")
    return null_files

directory = input("Enter the directory to search: ")
files_with_null = find_null_bytes(directory)

if files_with_null:
    print("Files containing null bytes:")
    for file in files_with_null:
        print(file)
else:
    print("No files with null bytes found.")
