#!/usr/bin/python
#
# Version 0.0.0.1

# Import module.
import zipfile

# Set filename.
PT_FILE = "embedding_file_name.pt"

# Open file for reading.
with zipfile.ZipFile(PT_FILE, mode="r") as archive:
    # Print file structure.
    archive.printdir()

