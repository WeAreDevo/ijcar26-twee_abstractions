import os
import shutil

from dotenv import load_dotenv

load_dotenv()
tptp_root = os.getenv("TPTP_ROOT")

script_dir = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_dir)

# TPTP_ROOT/Scripts/tptp2T UnitEquality Status Unsatisfiable should get all the unsatisfiable UEQ problems. You can also change Unsatisfiable to Unknown or Open to get unproved problems (Unknown = the TPTP problem has never been proved but expresses a mathematical statement that has been proved, Open = open problem).

# Paths
filter_file = 'UEQ_Unsat.txt'          # Path to the text document
status = "UNS"
# Read the text file and extract all first words
with open(filter_file, 'r') as f:
    target_names = {line.strip().split()[0] for line in f if line.strip()}

for theory in ["ALG", "BOO", "COL", "GRP", "LAT", "LCL", "REL", "RNG", "ROB"]:
    source_dir = f'{tptp_root}/Problems/{theory}'               # Source directory containing .p files
    output_dir = f'UEQ_{status}'   # Destination directory

    # Create output directory if it doesn't exist
    # os.makedirs(output_dir, exist_ok=False)


    # List all .p files in the source directory
    for filename in os.listdir(source_dir):
        file_stem, ext = os.path.splitext(filename)
        if ext == '.p' and file_stem in target_names:
            src_path = os.path.join(source_dir, filename)
            dst_path = os.path.join(output_dir, filename)
            # check if dst_path already exists
            # if os.path.exists(dst_path):
            #     print(f"File already exists, skipping: {dst_path}")
            #     continue
            shutil.copyfile(src_path, dst_path)
            print(f"Copied: {filename} from {source_dir} to {output_dir}")

print("Filtering complete.")