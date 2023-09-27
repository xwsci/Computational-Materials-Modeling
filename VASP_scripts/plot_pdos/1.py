import pandas as pd
import matplotlib.pyplot as plt

# Reading the data from the file using pandas
df = pd.read_csv("pdos.dat", delim_whitespace=True)

# Getting energy values
x = df["energy_up"].values

# Generating consistent colors for elements
colors = {
    'C': 'grey',
    'F': 'cyan',
    'H': 'green',
    'Nb': 'orange',
    'Ni': 'magenta',
    'N': 'blue',
    'O': 'red'
}

# Font size for uniformity
font_size = 12
plt.rcParams.update({'font.size': font_size})

# Plotting
plt.figure(figsize=(10, 6))

# Track which elements have been plotted for legend purposes
plotted_elements = set()

for column in df.columns[1:]:
    element = column.split('_')[0]  # Extract element name
    label = element if element not in plotted_elements else ""  # Only label the first occurrence
    plt.plot(x, df[column].values, label=label, color=colors[element])
    plotted_elements.add(element)

# Adding the dashed line at x = 0
plt.axvline(0, color='black', linestyle='--')
# Labeling the dashed line
plt.text(0.1, plt.gca().get_ylim()[1] - 0.1*(plt.gca().get_ylim()[1]-plt.gca().get_ylim()[0]), '$E_F$', verticalalignment='top')

plt.xlabel("Energy (eV)")
plt.ylabel("Density of State (a.u.)")
plt.xlim([-4, 2])  # Setting x-axis limits
plt.legend(loc="upper right")
plt.title("")
plt.grid("")

# Making the plot layout tighter
plt.tight_layout()

# Save the plot as PNG with 300 dpi resolution
plt.savefig("output_plot.png", dpi=300)
plt.show()
