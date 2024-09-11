# Introduction

<p align="justify">This subdirectory only contains <code>Bash</code> scripts that I use to prepare AI generated images for minting as NFTs.</p> 

# Bash Scripts

## <code>sd_aspect_ratio.bash</code>

### Explanation

<p align="justify">The script calculates a valid resolution in pixel based on a given aspect ratio. The lowest possible value for width and height of an image is 512 pixel. If one of these two sizes is smaller than 512 pixel the AI generator may have problems to create an image of desired quality. Since the Easy Diffusion values are divisible by 8, they result in meaningful values based on the binary number system. This way I using the preset values from Easy Diffusion to try to calculate a valid resolution in pixel.</p> 

<p align="justify">Easy diffusion has preset values for width and height, while AUTOMATIC1111 knows such a limitation not.</p> 

## <code>aspect_ratio.bash</code>

<p align="justify">The script <code>aspect_ratio.bash</code> calculates the aspect ratio of a given image using the greatest common divisor.</p>

# Abbreviations

Abbreviation | Description
:----|:------------------------------|
AI   | Artificial intelligence
Bash | Bourne-Again SHell
CALC | Calculation
EVAL | Evaluation
EXIF | Exchangeable Image File Format 
GCD  | Greatest Common Divisor
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

<hr width="100%" size="2">

<p align="center">I loved the time when you could get also a hamburger :hamburger: for one euro!</p>

<p align="center">
<a target="_blank" href="https://www.buymeacoffee.com/zentrocdot"><img src="..\IMAGES\greeen-button.png" alt="Buy Me A Coffee" height="41" width="174"></a>
</p>
<hr width="100%" size="2">

<p align="justify">If you like what I present here, or if it helps you, or if it is useful, you are welcome to donate a small contribution or a cup of coffee. Or as you might say: Every TRON counts! Many thanks in advance! :smiley:</p>

<pre>TQamF8Q3z63sVFWiXgn2pzpWyhkQJhRtW7            (TRON)
DMh7EXf7XbibFFsqaAetdQQ77Zb5TVCXiX            (DOGE)
12JsKesep3yuDpmrcXCxXu7EQJkRaAvsc5            (BITCOIN)
0x31042e2F3AE241093e0387b41C6910B11d94f7ec    (Ethereum)</pre>

[^1]: Side Note: The designations KiB, KB, MiB and MB must be checked against implementation and usage in the operating system and against the relevant international standards. For my current OS the conversion is consistent. 

