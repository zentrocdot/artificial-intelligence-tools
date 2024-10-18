#!/usr/bin/python3
'''Convert image to tensor and convert tensor back to image.'''
#
# Version 0.0.0.2
#
# Copyright © 2024, Dr. Peter Netz
# Published under the MIT license.
# https://github.com/zentrocdot/artificial-intelligence-tools/blob/main/LICENSE
#
# Remark:
# The script was checked using the linter pylint.

# Import the required Python modules.
from torchvision.transforms import transforms
from PIL import Image

# Set the file names.
FN_IN = "sample.jpeg"
FN_OUT = "sample_new.jpeg"

# Read a PIL image.
image_in = Image.open(FN_IN)

# Define a transform to convert a PIL image into a Torch tensor.
transform_tensor = transforms.Compose([transforms.PILToTensor()])

# Convert the PIL image into a Torch tensor
image_tensor = transform_tensor(image_in)

# Print the converted Torch tensor in short form into the screen.
print(image_tensor)

# Define a transform to convert the Torch tensor into a PIL image.
transform_image = transforms.ToPILImage()

# Create a new PIL image.
image_out = transform_image(image_tensor)

# Show the PIL image.
image_out.show()

# Save the PIL image.
image_out.save(FN_OUT, "jpeg", quality=95)
