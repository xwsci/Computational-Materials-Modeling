import matplotlib.pyplot as plt
import numpy as np
import os

# Load the data
data = np.loadtxt("data.txt")

# Extract the x values and y values
x = data[:, 0]
y1 = data[:, 1]
y2 = data[:, 2]

# Find the largest increase for y2 and its corresponding index
differences = np.diff(y2)
max_increase_index = np.argmax(differences)
max_increase_value = differences[max_increase_index]

# Plot the y1 values with solid lines for every two consecutive points
for i in range(0, len(x)-1, 2):
    plt.plot(x[i:i+2], y1[i:i+2], color="orange", label="U = 0 V" if i == 0 else "")

# Plot the y2 values with solid lines for every two consecutive points
for i in range(0, len(x)-1, 2):
    plt.plot(x[i:i+2], y2[i:i+2], color="blue", label="U = 1.23 V" if i == 0 else "")

# Connect the solid lines with dashed lines for y1
for i in range(1, len(x)-2, 2):
    plt.plot(x[i:i+2], y1[i:i+2], "--", color="orange")

# Connect the solid lines with dashed lines for y2
for i in range(1, len(x)-2, 2):
    plt.plot(x[i:i+2], y2[i:i+2], "--", color="blue")

# Draw a vertical double-headed arrow immediately beneath the solid line spanning [4,5]
arrow_x_position = x[max_increase_index] + 1
arrow_y_start = y2[max_increase_index+1]
min_arrow_length = 0.4
arrow_length = max(max_increase_value, min_arrow_length)
arrow_y_end = arrow_y_start - arrow_length #arrow_y_end = arrow_y_start - max_increase_value

plt.annotate('', xy=(arrow_x_position, arrow_y_end),
             xytext=(arrow_x_position, arrow_y_start),
             arrowprops=dict(arrowstyle='<->', color='blue', lw=1.5))

# Annotate the value of the largest increase for y2 beneath the arrow
annotation_x_position = arrow_x_position
annotation_y_position = arrow_y_end - 0.1
plt.text(annotation_x_position, annotation_y_position, f"η = {max_increase_value:.2f} V", color="blue", ha='center', va='center')

# Set the y-axis range
plt.ylim(-3, 3)

# Set the axis labels
plt.xlabel("Reaction Coordinate")
plt.ylabel("Free Energy (eV)")

# Display the legend
legend = plt.legend(handlelength=2, frameon=False, loc='upper right')
for text, color in zip(legend.get_texts(), ["orange", "blue"]):
    text.set_color(color)

# Get the current directory's name
current_directory = os.getcwd()
title = os.path.basename(current_directory)

# Set the title for the figure
#plt.title(title)

plt.xticks([])
plt.text(0.5, -2.8, r"$\mathrm{O}_2$", ha='center', va='center', fontsize=12, color="black")
plt.text(2.5, -2.8, "OOH*", ha='center', va='center', fontsize=12, color="black")
plt.text(4.5, -2.8, "O*", ha='center', va='center', fontsize=12, color="black")
plt.text(6.5, -2.8, "OH*", ha='center', va='center', fontsize=12, color="black")
plt.text(8.5, -2.8, r"$\mathrm{H}_2$"+"O", ha='center', va='center', fontsize=12, color="black")

plt.tight_layout()
#plt.show()
plt.savefig("orr.png", dpi=300)
