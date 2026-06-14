import csv
import random
import os
import sys

NUM_ROWS = 1337


COLUMNS = ["student_id", "GPA", "percentile", "specialization"]

def generate_row():

    return {
        "student_id": random.randint(9000000, 10000000),
        "GPA": round(random.uniform(1.5, 9.9), 2),
        "percentile": random.randint(0, 100),
        "specialization": random.choice(["MOP", "RS", "ADIS", "PR"]),
    }

OUTPUT_DIR = sys.argv[1] if len(sys.argv) > 1 else "/data"
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "data.csv")

os.makedirs(OUTPUT_DIR, exist_ok=True)

rows = [generate_row() for _ in range(NUM_ROWS)]

with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=COLUMNS)
    writer.writeheader()
    writer.writerows(rows)
