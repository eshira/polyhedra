/*  Pyritohedron https://en.wikipedia.org/wiki/Dodecahedron#Pyritohedron
    Preliminary exploration before working on magnetic tile code
    Vary h from -1 to 1.
    At h=0, a cube
    At h=1, a rhombic dodecahedron
    At -1<h<0 it pulls inwards and vanishes at h=-1
    h=0.5*(sqrt(5)-1); //Inverse golden ratio; regular dodecahedron
*/

h=0.8;

polyhedron(
    points =
        [
        [1,1,-1],
        [(1+h),(1-pow(h,2)),0],
        [1,1,1],
        [(1-pow(h,2)),0,(1+h)],
        [1,-1,1],
        [(1+h),-(1-pow(h,2)),0],
        [1,-1,-1],
        [(1-pow(h,2)),0,-(1+h)],  
        [0,-(1+h),-(1-pow(h,2))],
        [-1,-1,-1],
        [-(1+h),-(1-pow(h,2)),0],
        [-1,-1,1],
        [0,-(1+h),(1-pow(h,2))],
        [-(1-pow(h,2)),0,-(1+h)],
        [-1,1,-1],
        [-(1+h),(1-pow(h,2)),0],
        [-1,1,1],
        [-(1-pow(h,2)),0,(1+h)],
        [0,(1+h),-(1-pow(h,2))],
        [0,(1+h),(1-pow(h,2))]
        ], 
        
    faces = 
        [
        [5,4,3,2,1],
        [5,1,0,7,6],
        [12,4,5,6,8],
        [12,8,9,10,11],
        [11,10,15,16,17],
        [10,9,13,14,15],
        [16,15,14,18,19],
        [19,18,0,1,2],
        [3,4,12,11,17],
        [19,2,3,17,16],
        [7,0,18,14,13],
        [13,9,8,6,7],
        ]
); 
       
      
        

        
