#!/usr/bin/python
#
# Version 0.0.0.1
# Copyright © 2024, Dr. Peter Netz
# Published under the MIT license.
# https://github.com/zentrocdot/artificial-intelligence-tools/blob/main/LICENSE
#
# Description
# Create a tensor (scalar) with a complex number as element. Print the
# content of the tensor content, the number of elements and the dtype.

# Import the third party Python module.
import torch

# Create the real and the imaginary part of a complex tensor.
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
