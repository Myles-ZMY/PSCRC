ReadMe:

This is the matlab code of the paper submitted to Electronics Letters
Mingyong Zeng, et.al.
"Improving person re-identification by unsupervised pairwise-specific CRC coding in the XQDA subspace". 
2017.06.15

1.Download below GOG features for VIPeR from [1] and put them into ./data/VIPeR/
VIPeR_feature_all_GOGyMthetaHSV
VIPeR_feature_all_GOGyMthetaLab
VIPeR_feature_all_GOGyMthetanRnG
VIPeR_feature_all_GOGyMthetaRGB


2.Run 'demo.m' to reproduce the results of the paper.
The four GOG features are normalised and cascaded, the "mean reduce" strategy in GOG is applied on the whole dataset for simplicity.
Note that XQDA has been included from the author's web page http://www.cbsr.ia.ac.cn/users/scliao/projects/lomo_xqda/.


3.You can uncomment 'metricname='L2'' to test the baseline L2 metric for comparison. 


[1] T. Matsukawa, T. Okabe, E. Suzuki, Y. Sato, 
"Hierarchical Gaussian Descriptor for Person Re-Identification", 
In Proceedings of IEEE Conference on Computer Vision and Pattern Recognition (CVPR), pp.1363-1372, 2016.

