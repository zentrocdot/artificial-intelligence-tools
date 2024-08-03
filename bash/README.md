# Introduction

<p align="justify">This subdirectory only contains <code>Bash</code> scripts that I use to prepare AI generated images for minting as NFTs.</p> 

# Bash Scripts

## <code>analyse_exif_metadata.bash</code>

### Explanation

<p align="justify">The task of the script <code>analyse_exif_metadata.bash</code> is to analyse the EXIF metadata in an given image. On the one hand, the script should ensure that the correct EXIF metadata is contained in the image before publication as NFT. On the second hand, the extracted, determined and calculated data is required in the publishing process as NFT.</p> 

<p align="justify">To mine an NFT, you need e.g. a local installation or you can use an Internet service like OpenSea [1] or Rarible [2]. The first involves a lot of effort. The second is quick and easy. An NFT consists of two parts, a contract on the blockchain and an image to be stored externally. If one use OpenSea or Rarible and prepare an NFT for minting in the related Web UI, then one needs next to Collection, Name and Supply the so-called Traits to describe the image.</p> 

<p align="justify">The script <code>analyse_exif_metadata.bash</code> extracts, determines and calculates data, which can be used for the previously described Traits.</p>

Some of my traits are:
- Category (e.g. Avatar, Vehicle, Mushroom)
- Orientation (e.g. Portrait, Landscape or None)
- Aspect Ratio (e.g. 2:3, 19:9, 1:1)
- Wallpaper (e.g. Yes, No or Unknown)

<p align="justify">Category will be extracted from my EXIF metadata. Orientation is derived from the data. Aspect Ratio values and Wallpaper string are calculated.</p>  

### Sample Printout

An example printout looks like this

<pre>
**********************
EXIF Metadata Analysis
**********************

Filename:                   0f8acf268f58060702f32ef0d51bcfb4.jpeg
MD5 Hash:                   0f8acf268f58060702f32ef0d51bcfb4
AI Generator (EVAL):        Stable Diffusion
AI Web UI (EVAL):           AUTOMATIC1111
Category (EVAL):            Mushroom
Copyright (EXIF):           2024, zentrocdot
Creator: (EXIF)             zentrocdot
Creator Tool (EXIF):        AI Generator Stable Diffusion, AI WebUI AUTOMATIC1111
Comment (EXIF):             Fantastic Mushroom Collection
User Comment (EXIF):        Selected image for minting as NFT
File Type (EXIF):           JPEG
File Type Extension (EXIF): jpg
Mime Type (EXIF):           image/jpeg
File Size (MiB):            3.5 MiB
File Size (MB):             3.7 MB
Image Width (EXIF):         8192
Image Height (EXIF):        4608
Image Size (EXIF):          8192 x 4608 pixel
Image Size (EVAL):          8192 x 4608 pixel
Aspect Ratio (CALC):        16:9
Orientation (EVAL):         Landscape
Resolution: (EVAL)          Unknown
Wallpaper: (CALC)           Yes

Have a nice day. Bye!</pre>

<p align="justify">The previous printout shows an open problem I have. File type, file type extension and mime type are inconsistent. This has to be checked.</p>

<p align="justify">Technically speaking, JPG and JPEG are exactly the same thing.</p>



### TO-DO

### Finel Remark

<p align="justify">The script is in a way written, that it can easily be adapted to the needs of another user.</p>

# References

[1] https://opensea.io/

[2] https://rarible.com/

# Abbreviations

Abbreviation | Description
:----|:------------------------------|
AI   | Artificial intelligence
Bash | Bourne-Again SHell
CALC | Calculation
EVAL | Evaluation
EXIF | Exchangeable Image File Format 
GB   | Gigabyte
GiB  | Gibibyte
IPFS | InterPlanetary File System
JPG  | Joint Photographic (Experts) Group
JPEG | Joint Photographic Experts Group
KB   | Kilobyte
KiB  | Kibibyte
MB   | Megabyte
MiB  | Mebibyte
NFT  | Non-Fungible Token
PNG  | Portable Network Graphics

# Glossary

Denotation | Description
:----------|:--------------------------------------------------------------------------------------------------------------|
Trait      | A Trait describes an attribute of an item and consists of Type and Name. E.g. Type is Size and Name is Large or Small 
KB  [^1]   | 1 KB = 1000 Byte 
KiB        | 1 KiB = 1024 Byte, 1 KiB = 1.024 KB
MB  [^1]   | 1 MB = 1000 KB
MiB        | 1 MiB = 1024 KiB, 1 MiB = 1.024 MB

[^1]: Side Note: The designations KiB, KB, MiB and MB must be checked against implementation and usage in the operating system and against the relevant international standards. For my current OS the conversion is consistent. 

