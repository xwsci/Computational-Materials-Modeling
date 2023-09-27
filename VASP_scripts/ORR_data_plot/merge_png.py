from PIL import Image
import os

def merge_images(imgs):
    # Assuming all images are of the same size
    width, height = imgs[0].size
    result_width = 2 * width
    result_height = 2 * height
    result = Image.new("RGBA", (result_width, result_height))
    
    positions = [(0, 0), (width, 0), (0, height), (width, height)]
    
    for pos, img in zip(positions, imgs):
        result.paste(img, pos)
    
    return result

def main():
    folder_path = './'  # path to the folder containing the PNG files
    output_folder = './'  # where you want the merged images to be saved

    # Get all png files in the folder
    png_files = [f for f in sorted(os.listdir(folder_path)) if f.endswith('.png')]

    for i in range(0, len(png_files), 4):
        # Collect the next 4 images
        images = [Image.open(os.path.join(folder_path, png_files[j])) for j in range(i, i+4)]

        # Merge the 4 images
        merged_image = merge_images(images)

        # Save the merged image
        merged_image.save(os.path.join(output_folder, f"{(i//4) + 1}.png"))

if __name__ == "__main__":
    main()
