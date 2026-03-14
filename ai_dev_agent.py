import subprocess
import os
from openai import OpenAI

client = OpenAI()

CHANGELOG = "CHANGELOG.md"

# -----------------------------
# get repository files
# -----------------------------

files = subprocess.check_output(["git","ls-files"]).decode().splitlines()

ignore = [
    "CHANGELOG.md",
    ".gitignore"
]

files = [f for f in files if f not in ignore]

if not files:
    print("No repo files found.")
    exit()

file_list = "\n".join(files[:40])

# -----------------------------
# AI selects file
# -----------------------------

selection_prompt = f"""
You are reviewing a software repository.

Choose ONE file that could benefit from a small improvement.

Allowed improvements:
- documentation
- readability
- comments
- small bug fixes
- README cleanup

Return ONLY the filename.

FILES:
{file_list}
"""

resp = client.responses.create(
    model="gpt-4.1",
    input=selection_prompt
)

target = resp.output_text.strip()

print("Selected file:", target)

if target not in files:
    print("Model returned invalid file. Aborting.")
    exit()

# -----------------------------
# read file
# -----------------------------

with open(target,"r") as f:
    original = f.read()

# -----------------------------
# AI improves file
# -----------------------------

improve_prompt = f"""
Improve this file slightly.

Rules:
- do not change functionality
- only readability or documentation
- return the FULL updated file
- no explanation

FILE:
{original}
"""

resp2 = client.responses.create(
    model="gpt-4.1",
    input=improve_prompt
)

updated = resp2.output_text

if updated.strip() == original.strip():
    print("No improvement made.")
    exit()

# -----------------------------
# write file
# -----------------------------

with open(target,"w") as f:
    f.write(updated)

print("File updated.")

# -----------------------------
# generate diff
# -----------------------------

diff = subprocess.check_output(["git","diff",target]).decode()

if not diff.strip():
    print("No diff detected.")
    exit()

# -----------------------------
# AI writes changelog entry
# -----------------------------

changelog_prompt = f"""
Write ONE changelog bullet describing this change.

Rules:
- 5 to 15 words
- no punctuation at start
- no explanation

DIFF:
{diff}
"""

resp3 = client.responses.create(
    model="gpt-4.1",
    input=changelog_prompt
)

entry = resp3.output_text.strip()

print("Changelog entry:", entry)

# -----------------------------
# insert into CHANGELOG
# -----------------------------

if not os.path.exists(CHANGELOG):
    with open(CHANGELOG,"w") as f:
        f.write("# Changelog\n\n## Unreleased\n")

with open(CHANGELOG,"r") as f:
    lines = f.readlines()

insert_index = None

for i,line in enumerate(lines):
    if line.strip().lower() == "## unreleased":
        insert_index = i+1
        break

if insert_index is None:
    lines.append("\n## Unreleased\n")
    insert_index = len(lines)

lines.insert(insert_index,f"- {entry}\n")

with open(CHANGELOG,"w") as f:
    f.writelines(lines)

print("CHANGELOG updated.")