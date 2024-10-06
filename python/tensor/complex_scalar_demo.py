#!/usr/bin/python

# Import the Python module.
import torch

# Create real and imaginary part of a complex tensor.
real = torch.tensor([1], dtype=torch.float32)
imag = torch.tensor([1], dtype=torch.float32)

# Create a new complex tensor.
z = torch.complex(real, imag)

# Print the created tensor.
print(z)

# Print the size of the tensor.
print(z.size())

# Print the dtype of the tensor.
print(z.dtype)


#print(z.dim())
#print(z.stride())
#print(z.numel())
#print(z.element_size())
#print(z.shape)
