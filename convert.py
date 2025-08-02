from PIL import Image

# Load image
img = Image.open("/home/acornfish/Pictures/wave.png")

# Convert to indexed palette (optional if already indexed)
indexed_img = img.convert("P", palette=Image.ADAPTIVE, colors=16)

# Get the palette indexes as a 2D array
pixels = list(indexed_img.getdata())
width, height = indexed_img.size
pixel_indexes = [pixels[i * width:(i + 1) * width] for i in range(height)]

indexes = ([ x for xs in pixel_indexes for x in xs ])
print(indexes)
for i in range(len(indexes)): 
    x = str(indexes[i])
    x = x.replace("19", "0")
    x = x.replace("21", "1")
    x = x.replace("4", "2")
    x = x.replace("3", "3")
    indexes[i] = x

print(",".join(indexes))