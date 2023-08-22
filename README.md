# Robotics, Vision & Control: 3rd edition in MATLAB (2023)

[![codecov](https://codecov.io/gh/petercorke/RVC3-MATLAB/branch/main/graph/badge.svg?token=68OAE87GM2)](https://codecov.io/gh/petercorke/RVC3-MATLAB)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://choosealicense.com/licenses/mit/)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/petercorke/RVC3-MATLAB/graphs/commit-activity)
[![GitHub stars](https://img.shields.io/github/stars/petercorke/RVC3-MATLAB.svg?style=social&label=Star&maxAge=2592000)](https://GitHub.com/petercorke/RVC3-MATLAB/stargazers/)

<table style="border:0px">
<tr style="border:0px">
<td style="border:0px">
<img src="https://github.com/petercorke/RVC3-MATLAB/raw/main/doc/978-3-031-07261-1_5208.png" alt="Front cover 978-3-031-07261-5_5208" width="300">
</td>
<td style="border:0px">
Welcome to the online hub for the book:
<ul type="none">
<li><b>Robotics, Vision & Control</b>: fundamental algorithms in MATLAB (3rd edition) 
<li>Peter Corke, Witold Jachimczyk and Remo Pillat, published by Springer-Nature 2023.</li>
<li><b>ISBN</b> 978-3-031-07261-1 (hardcopy), 978-3-031-07262-8 (eBook)</li>
<li><b>DOI</b> <a href="https://doi.org/10.1007/978-3-031-07262-8">10.1007/978-3-031-07262-8</a></li>
</ul>
<br><br>
<p>Report an issue with the book or its supporting code <a href="https://github.com/petercorke/RVC3-MATLAB/issues/new/choose">here</a>.</p>

<p>Known errata for the book can be viewed <a href="https://github.com/petercorke/RVC3-MATLAB/wiki/Errata">here</a>.</p>
</td>
</tr>
</table>

This repo contains MATLAB code resources that support the book:

* [LiveScripts](book/code), one per chapter, that provide all the code examples used in a chapter
* the [RVC3 toolbox](toolbox) which extends the MathWorks Toolboxes and is required to run the
  chapter examples.
* the [code](book/figures) that creates all the MATLAB-generated figures in the book

# Accessing the chapter LiveScripts

There are two ways to do this.

## Open in MATLAB Online™

This is the zero-install option, and requires that you have a MATLAB Online licence.
MATLAB Online can work on a tablet, but not a phone.

Use the QR code at the start of a chapter that looks like this:

<img src="https://github.com/petercorke/RVC3-MATLAB/raw/main/doc/QRcode.png" alt="QR code for Chapter 2" width="500">

and then do one of the following:
* click the hotlink  `▶sn.pub/KI1xtA`  in an e-book, 
* point your tablet camera at the QR code and go to the URL, or
* type the short URL `sn.pub/KI1xtA` into your browser.

This will clone the repository into your MATLAB Drive and open the chapter LiveScript
in a browser tab.  

## Open in desktop MATLAB session

You need to have MATLAB installed and the required Toolboxes.  Install the extra
resources
```shell
git clone git@github.com:petercorke/RVC3-MATLAB.git
```
or
```shell
git clone https://github.com/petercorke/RVC3-MATLAB.git
```

Once installed you need to open the `RVC3` project which will add the RVC3 Toolbox to
your path.  Simply double-click the `rvc3setup.prj` file in the top-level folder.

Then open the appropriate file from the folder `book/code` where Chapter N is in a file
named `chapterN.mlx`.  You can open the file by:
* double-clicking in the MATLAB file browser, or
* from the MATLAB consolde by `>> chapterN`
* programatically by `open("chapterN")`


## Required toolboxes

To run the examples in this book you need to have a MATLAB® licence, as well as a number
of licenced MathWorks software products.


For Parts I, II, III:
- **Robotics System Toolbox**™
- Optimization Toolbox™
- Simulink®
- Symbolic Math Toolbox™
- UAV Toolbox
- Navigation Toolbox™

For Parts IV and Chap. 15
- **Computer Vision Toolbox**™
- **Image Processing Toolbox**™
- Signal Processing Toolbox™
- Deep Learning Toolbox™
- Statistics and Machine Learning Toolbox™


For Chap. 16 only:
- ROS Toolbox
- Model Predictive Control Toolbox™
- Automated Driving Toolbox™

Those shown in bold are sufficient to run a large subset
of the code examples.
## Apps

This package provides additional interactive tools including:
- `tripleangledemo`, experiment with various triple-angle sequences.
# Block diagram models

These are included in the RVC3 Toolbox as files named `sl_XXXX.slx` which can be opened
in Simulink by:

* double-clicking in the MATLAB file browser, or
* from the MATLAB consolde by `>> sl_XXXX`
* programatically by `open("sl_XXXX")`


# Additional book resources

This GitHub repo provides additional resources for readers including:
- The code to produce every MATLAB figure in the book, see the [`book/figures`](book/figures) folder
- All example scripts, see the [`toolbox/examples`](toolbox/examples) folder.
- To run the visual odometry example in Sect. 14.8.3 you need to download two image sequence, each over 100MB:
```
>> fetchExampleData
``` 

# MATLAB versions

This book requires that you have at least MATLAB R2023a in order to access all the
required MATLAB language and toolbox features. The code examples rely on recent MATLAB
language extensions:
* strings which are delimited by double quotation marks (introduced
in 2016b)
* `name=value` syntax for passing arguments to functions (introduced in
2021a), for example, `plot(x,y,LineWidth=2)` instead of the old-style `plot(x,y,"LineWidth",2)`.
