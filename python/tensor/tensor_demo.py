#!/usr/bin/python

# Import the standard Python module.
import sys

# Import the third party Python module.
import torch
import numpy

# Set the escape sequence for resetting the screen.
reset = "\033c"

# Reset the screen.
sys.stdout.write(reset)

# Set some print options torch.
torch.set_printoptions(edgeitems=1)
torch.set_printoptions(threshold=10)

# Set some print options numpy.
numpy.set_printoptions(edgeitems=1)
numpy.set_printoptions(threshold=10)

# Create a new tensor.
tensor = torch.tensor((), dtype=torch.float64)

# Fill the tensor with random numbers.
tensor = torch.randint(0, 10, (4,4,4,4))

# Print the tensor using torch.
print(tensor)

# Print the tensor using numpy.
print(tensor.numpy())

# Print thze size of the tensor.
print(len(tensor.size()))

# Print the number of elements of the tensor.
print(tensor.numel())

# Print the dtype of the tensor.
print(tensor.dtype)
