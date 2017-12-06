/*  Pyritohedron https://en.wikipedia.org/wiki/Dodecahedron#Pyritohedron
    Preliminary exploration before working on magnetic tile code
    Vary h from -1 to 1.
    At h=0, a cube
    At h=1, a rhombic dodecahedron
    At -1<h<0 it pulls inwards and vanishes at h=-1
    h=0.5*(sqrt(5)-1); //Inverse golden ratio; regular dodecahedron
*/

/*  length in mm
    distance of the fixed points from origin
    (see animation on wikipedia; size of side of starting cube)
    For the cube, this is half the length of a side
    For the rhombus, this is half the shorter diagonal
    For the pentagonal cases, this is the distance between a specific pair of vertices
*/
tilesize = 20;
thickness =7;

h=0.5; //single parameter to define this shape

function dot(v = [1,0,0], w = [0,1,0]) = v[0]*w[0]+v[1]*w[1]+v[2]*w[2]; //dot product of two vectors
function angle(v = [1,1,1], w = [1,1,1]) = acos(dot(v,w)/(norm(v)*norm(w)));  //angle between two vectors

function deg2rad(degs = 0) = degs*PI/180;
function rad2deg(rads = 0) = rads*180/PI;

module pyritohedron(h=0.5*(sqrt(5)-1)){
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
}

theta = -angle(v=[1,0,0],w=[-pow(h,2)-h,0,(1+h)]); // dihedral angle #1, 'base-to-base'
ry = [[cos(theta),0,sin(theta)],[0,1,0],[-sin(theta),0,cos(theta)]]; //y axis rotation
f1v1 = [(1+h),0,0] - [(1+h),(1-pow(h,2)),0]; //vector1 used to define face1
f1v2 = [(1+h),0,0] - [(1-pow(h,2)),0,(1+h)]; //vector 2 used to define face1
f2v1 = [0,-(1+h),0] - [(1+h),-(1-pow(h,2)),0]; //vector 1 used to define face2
f2v2 = [0,-(1+h),0] - [0,-(1+h),-(1-pow(h,2))]; //vector 2 used to define face2
norm1 = cross(f1v1,f1v2); //normal vector to face1
norm2 = cross(f2v1,f2v2); //normal vector to face2
phi = angle(v=norm2,w=norm1); //dihedral angle #2, 'sideA-to-sideB'

//pyritohedron(h); //pyritohedron solid model

facepoints3d = [
                [0,(1-pow(h,2)),0]*ry,
                [-h,1,1]*ry,
                [(-pow(h,2)-h),0,(1+h)]*ry,
                [-h,-1,1]*ry,
                [0,-(1-pow(h,2)),0]*ry
             ];

facepoints = [
                [facepoints3d[0][0],facepoints3d[0][1]],
                [facepoints3d[1][0],facepoints3d[1][1]],
                [facepoints3d[2][0],facepoints3d[2][1]],
                [facepoints3d[3][0],facepoints3d[3][1]],
                [facepoints3d[4][0],facepoints3d[4][1]],
             ];

difference(){
    linear_extrude(height=thickness,center=false){
        scale([tilesize,tilesize,tilesize]){
            polygon(points = facepoints);
        }
    }
    interior1 = angle(v=(facepoints3d[3]-facepoints3d[4]),w=facepoints3d[4]);
    rotate([0,90-abs(theta)/2,0]) translate([-tilesize,-tilesize,0]) cube([tilesize,2*tilesize,2*tilesize]);
    translate(facepoints[4]*tilesize) rotate([0,0,interior1]) rotate([0,90-phi/2,0]) translate([-tilesize,-1.5*tilesize,0]) cube([tilesize,2*tilesize,2*tilesize]);
    mirror([0,1,0]) translate(facepoints[4]*tilesize) rotate([0,0,interior1]) rotate([0,90-phi/2,0]) translate([-tilesize,-1.5*tilesize,0]) cube([tilesize,2*tilesize,2*tilesize]);
}