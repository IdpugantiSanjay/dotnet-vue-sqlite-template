import os
import subprocess
import sys
from typing import Optional


def check_for_file_presence() -> Optional[str]:
    for file in [
        "{{ cookiecutter.public_key_path }}",
        "{{ cookiecutter.private_key_path }}",
    ]:
        if not os.path.isfile(file):
            return file



if __name__ == "__main__":
    result = check_for_file_presence()
    if result:
        print(f"ERROR: {result} if not present or is not a file", file=sys.stderr)
        sys.exit(1)