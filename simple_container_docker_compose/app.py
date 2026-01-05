import pandas as pd 
import sys
import matplotlib.pyplot as plt
from pathlib import Path

print("\n\n")
print(f"{sys.version =}")

data = {
    "Name": ["Erik", "Anna", "Johan", "Lisa", "Oskar"],
    "Age": [28, 34, 40, 25, 50],
    "City": ["Stockholm", "Göteborg", "Malmö", "Uppsala", "Lund"],
    "Salary": [45000, 32000, 20000, 25000, 30000] 
}


df = pd.DataFrame(data)

fig, ax = plt.subplots(1)
ax.bar(x = df["Name"], height = df["Age"])
fig.savefig(Path(__file__).parent / "ages.png")
fig.tight_layout()

print(df.head())