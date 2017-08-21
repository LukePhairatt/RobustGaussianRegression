## **FFT Robust Gaussian Regression for Defect Detection**

![2d image][image0]
![3d image][image1]
---

[//]: # (Image References)
[image0]: ./image/AutomatedDefectDetection.png "result 2d"
[image1]: ./image/PointCloudDefect.png "result 3d"
[RGR]:    ./src/Matlab/RGRFilter/RGR2_FFT.m

# **Overview**
Algorithm for micro defect detections. The core idea is to use RGR to re-engineer the nominal surface form for thresholding.  
The binary surface residuals can then be detected using convention image processing techniques. [(RGR FFT)](RGR)


**Running**  
Running the main file > TestRGR.m

