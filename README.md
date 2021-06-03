# Efficient UAV placement to serve maximum users through minimum UAVs

[Paper](https://arxiv.org/abs/2009.13158), [Spotlight Presentation](https://youtu.be/T3m57pNdrqE)

## Introduction
This repository contains the implementation of efficient UAV placement on predefined potential discrete locations. The objective is to serve a set number of user devices using minimum number of UAVs. 

In order to run the attached code, following softwares and packages are required to installed first:

1. Matlab, 2016 or later 
2. OPTI toolbos which can be installed from https://www.inverseproblem.co.nz/OPTI/index.php/DL/DownloadOPTI 

Both Linux and Windows OS are supported.

## Program flow

1. Set the desired inputs, provided in the start of the main_UAV_placement.m file.
2. Three algorithms are implementated to solve the problem. These are: Genetic algorithm (GA), Estimation of distribution algorithm (EDA), and branch and bound (BB).
3. The user is given an option to select any of them. The user can select all of the three.
4. The RunBB.m contains the implementation of branch and bound. If the RunBB successfully finds a feasible solution, only then RunGA and RunEDA is executed.
5. Inside RunGA and RunEDA, an unconstained optimization problem is solved.
6. When the GA and EDA completed their iterations, the final best solution is repaired to remove any potential constraint violation.
7. Finally, the results are stored in a .mat file for furture reference.
8. Run the main_UAV_placement.m file. 

## Results
The results are stored in a cell. Later on the results are plotted in ms excel. The same results can be easily plotted in matlab. Please feel free to email us if you require any help to generate plotsa nd graphs. 

## Citation
If you use this work (or any part of this code in your research), please cite the following paper:

```
@ARTICLE{9313991,
  author={Ahmed, Ashfaq and Naeem, Muhammad and Al-Dweik, Arafat},
  journal={IEEE Access}, 
  title={Joint Optimization of Sensors Association and UAVs Placement in IoT Applications With Practical Network Constraints}, 
  year={2021},
  volume={9},
  number={},
  pages={7674-7689},
  doi={10.1109/ACCESS.2021.3049360}}
```

## Contact
If you have any query, please feel free to contact us at: ashfaq.ahmed@ku.ac.ae.

## Disclaimer
Copyright © 2020 IEEE. Personal use of this material is permitted.
However, permission to use this material for any other purposes must be
obtained from the IEEE by sending an email to pubs-permissions@ieee.org.
