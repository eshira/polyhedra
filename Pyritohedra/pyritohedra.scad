/*  Pyritohedron https://en.wikipedia.org/wiki/Dodecahedron#Pyritohedron
    Vary h from 0 to 1.
    At h=0, a cube
    At h=1, a rhombic dodecahedron
    h=0.5*(sqrt(5)-1); //Inverse golden ratio; regular dodecahedron
*/

//BEGIN user defined variables section

/*  Set the tilesize variable to control the overall size of this shape. Units are millimeters.
    The length in mm representing the distance of the fixed points from the origin. Use to control overall size.
    For the cube, this is half the length of a side
    For the rhombus, this is half the shorter diagonal
    For the pentagonal cases, this is the distance between a specific pair of vertices
*/
tilesize = 14;

/*  Set the thickness variable to control the thickness of the tiles. Units are millimeters.
    If larger than the max height (computed later as variable 'ztop') this will throw off the centering of the magnet holes
*/
thickness = 8;//24.9035;

/*  The diameter of the magnet hole. Units are millimeters. */
magdiam = 6.5;

/*  The depth of the magnet hole. Units are millimeters.   */
magdepth=1.25;

/*  The parameter that controls the type of shape, from 0 to 1
    Use 0.9999999999999999 instead of 1 to avoid NaN in the matrices */
h=0.3;


//END of user controlled variables section






$fn=200;

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
//Actually theta as computed above is half the 360-complement of the actual dihedral
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
             
theta1 = (360+theta*2);    //Here I convert theta to be half of the actual dihedral angle
interior1 = angle(v=(facepoints3d[3]-facepoints3d[4]),w=facepoints3d[4]);
interior2 = angle(v=(facepoints3d[3]-facepoints3d[1]),w=(facepoints3d[2]-facepoints3d[1]));
   
module magnets() {
    angle2 = angle(v=facepoints3d[1]-facepoints3d[2],w=[0,1,0]);
    length2 = norm(facepoints3d[2]-facepoints3d[1]);
    x = tilesize*facepoints3d[2][0] - tilesize*cos(90-angle2)*length2/2;
    y = tilesize*facepoints[2][1] + tilesize*sin(90-angle2)*length2/2;
    angle1 = angle(v=facepoints3d[0]-facepoints3d[1],w=[0,1,0]);
    length1 = norm(facepoints3d[0]-facepoints3d[1]);
    x1 = 0 + tilesize*(cos(90-angle1)*length1/2);
    y1 = tilesize*facepoints3d[0][1] - tilesize*(sin(90-angle1)*length1/2);

    /*  Take the normals to two planes
        Take the cross product, to get the intersecting line.
        The tip is on the y=0 plane
        Solve for the tip
    */

    //Normal vector for the base face, plane1
    p1v = [cos(theta1/2),0,sin(theta1/2)];
    plane1 = cross(p1v,[0,1,0]);

    //Normal vector for the left face, plane2
    comp = -90+phi/2;
    ry2 = [[cos(comp),0,sin(comp)],[0,1,0],[-sin(comp),0,cos(comp)]]; //y axis rotation
    rz = [[cos(angle1),-sin(angle1),0],[sin(angle1),cos(angle1),0],[0,0,1]]; //z axis rotation
    r = rz*ry2; //rotation in order to put points on the correct plane
    test = r*[0,-tilesize/2,tilesize] + [0,tilesize*facepoints3d[0][1],0] ;
    testp1 =tilesize*(facepoints3d[1]);
    testp2 = tilesize*facepoints3d[0];
    plane2 = cross(test-testp2,testp1-testp2)/25;

    //Cross product of both planes yields the intersecting vector
    intersection1 = cross(plane1,plane2); //the point along this lines where y=0 is the tip

    //Solve for the y=0 point along that line (offset by facepoints3d[0] point of the base)
    t = -tilesize*facepoints3d[0][1]/intersection1[1];
    xtop = tilesize*facepoints3d[0][0]+t*intersection1[0];
    ztop = tilesize*facepoints3d[0][2]+t*intersection1[2];
    ytop=0;

    mag_t = 0.5*thickness/ztop;
    //Line between base of magnet and top, mag_t portion
    //Line between origin and the top
    yoffset = abs(tilesize*facepoints3d[0][1]/2);
    translate([mag_t*xtop,mag_t*(ytop-yoffset)+yoffset,mag_t*ztop]) rotate([0,-theta,0]) translate([0,0,-1]) cylinder(d=magdiam,h=magdepth+1);
    translate([mag_t*xtop,mag_t*(ytop+yoffset)-yoffset,mag_t*ztop]) rotate([0,-theta,0]) translate([0,0,-1]) cylinder(d=magdiam,h=magdepth+1);
    //MAGNET HOLES

    translate([mag_t*(xtop-x)+x,mag_t*(ytop-y)+y,mag_t*ztop]) rotate([0,phi/2,angle(v=facepoints3d[1]-facepoints3d[2],w=[0,1,0])]) translate([0,0,-magdepth]) cylinder(d=magdiam,h=magdepth+1);

    mirror([0,01,0]) translate([mag_t*(xtop-x)+x,mag_t*(ytop-y)+y,mag_t*ztop]) rotate([0,phi/2,angle(v=facepoints3d[1]-facepoints3d[2],w=[0,1,0])]) translate([0,0,-magdepth]) cylinder(d=magdiam,h=magdepth+1);

    translate ([mag_t*(xtop-x1)+x1,mag_t*(ytop-y1)+y1,mag_t*ztop]) rotate([0,phi/2,angle(v=facepoints3d[0]-facepoints3d[1],w=[0,1,0])]) translate([0,0,-magdepth]) cylinder(d=magdiam,h=magdepth+1);
    mirror([0,1,0]) translate ([mag_t*(xtop-x1)+x1,mag_t*(ytop-y1)+y1,mag_t*ztop]) rotate([0,phi/2,angle(v=facepoints3d[0]-facepoints3d[1],w=[0,1,0])]) translate([0,0,-magdepth]) cylinder(d=magdiam,h=magdepth+1);
}

difference(){
    //WALLS
    linear_extrude(height=thickness,center=false){
        scale([tilesize,tilesize,tilesize]){
            polygon(points = facepoints);
        }
    }
    rotate([0,90-abs(theta1)/2,0]) translate([-tilesize,-tilesize,0]) cube([tilesize,2*tilesize,2*tilesize]);
    translate(facepoints[4]*tilesize) rotate([0,0,interior1]) rotate([0,90-phi/2,0]) translate([-tilesize,-1.75*tilesize,0]) cube([tilesize,2*tilesize,2*tilesize]);
    mirror([0,1,0]) translate(facepoints[4]*tilesize) rotate([0,0,interior1]) rotate([0,90-phi/2,0]) translate([-tilesize,-1.75*tilesize,0]) cube([tilesize,2*tilesize,2*tilesize]);
    translate([tilesize*facepoints[2][0],0,0]) rotate([0,0,interior2]) translate([0,-tilesize/6,0]) rotate([0,-90+0.5*phi,0]) cube([tilesize,2*tilesize,2*tilesize]);
    mirror([0,1,0]) translate([tilesize*facepoints[2][0],0,0]) rotate([0,0,interior2]) translate([0,-tilesize/6,0]) rotate([0,-90+0.5*phi,0]) cube([tilesize,2*tilesize,2*tilesize]);
    magnets();
}

