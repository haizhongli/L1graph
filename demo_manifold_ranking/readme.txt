There are two demo scripts. 

demo_1: demonstrate the use of normalised graph Laplacian (L_n) for manifold ranking. Please refer to Eqn 4 in [1] for details.
demo_2: demonstrate the use of unnormalised graph Laplacian (L_u) for manifold ranking. Please refer to Eqn 5 in [1] for details.

If you have an distance matrix W ready, just use vsComputeLaplacian([],[],neighbour,W) to obtain the Laplacian matrix.

There is a parameter alpha that governs the performance of manifold ranking. In general, L_n is more sensitive to this parameter than L_u.

L_u has an additional parameter mparam. Setting it's value to 2 is usually sufficient.

[1] Person Re-Identification by Manifold Ranking 
    C. C. Loy, C. Liu, and S. Gong 
    in Proceedings of IEEE International Conference on Image Processing, 2013 (ICIP)