/*
Trapezohedra with magnets tile, by eshira
Use axially aligned magnets (4 per tile).
The tiles are split into two groups with distinct magnet patterns:
The top half and bottom half of the trapezohedron.
The long sides of a tile must have opposite poles facing out
All tiles from both groups must be identical with respect to the long sides.
The short sides of a tile must have opposite poles facing out
One group must have the opposite polarity of the other group with respect to the short sides.
*/

//User Defined Variables
side = 40; //side length of the short side
thickness = 10; //how thick (z dimension) the tile is
magnetdepth = 2.5; //depth of the magnet holes; tailor this to suit your 3d printer
magnetdiam = 6.5; //diameter of the magnet holes; tailor this to suit your 3d printer

//Other
$fn=50;
M_PI = 3.14159265359;

//Choose one from the following tile types to uncomment:
//trigonal();
tetragonal();
//pentagonal();
//hexagonal();
//heptagonal();
//octagonal();

module magnetA(dihedral,alpha, side2) {
    sdiag = side*sqrt( 2*(1-cos(alpha)) ); //short diagonal of the kite
    ldiag = sin(alpha)*side2/sin(alpha/2); //long diagonal of the kite 
    t_h = 0.5*side*(1/cos(alpha/2))*sin(alpha/2)*sin(dihedral/2)/sin(90-0.5*dihedral);   
    ptr = .5*thickness/t_h;
    extra=.1;
    //Place the magnet in the exact middle of the face; mix movement along long diagonal with movement along side, weighed by ptr
    translate([ptr*0.5*side*(1/cos(alpha/2))*cos(alpha/2)-0.5*(1-ptr)*side*sin(alpha-90),ptr*0.5*side*(1/cos(alpha/2))*sin(alpha/2)+0.5*(1-ptr)*side*sin(alpha),ptr*t_h]){
        rotate([180-dihedral/2,0,alpha]){
            translate([0,0,-extra]){
                linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
            }
        }
    }
}

module magnetB(dihedral,alpha,side2){
    sdiag = side*sqrt( 2*(1-cos(alpha)) ); //short diagonal of the kite
    ldiag = sin(alpha)*side2/sin(alpha/2); //long diagonal of the kite 
    t_h = 0.5*side*(1/cos(alpha/2))*sin(alpha/2)*sin(dihedral/2)/sin(90-0.5*dihedral);   
    ptr = .5*thickness/t_h;
    extra=.1;
    //Place the magnet in the exact middle of the face; mix movement along long diagonal with movement along side, weighed by ptr

    translate([side-ptr*0.5*side*(1/cos(alpha/2))*cos(alpha/2)+0.5*(1-ptr)*side2*cos(180-alpha),ptr*0.5*side*(1/cos(alpha/2))*sin(alpha/2)+0.5*(1-ptr)*side2*sin(180-alpha),ptr*t_h]){
        rotate([-180+dihedral/2,0,180-alpha]){
            translate([0,0,-extra]){
                linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
            }
        }

    }
}

module magnets(dihedral,alpha,side2){
    magnetA(dihedral,alpha,side2);
    magnetB(dihedral,alpha,side2);
    mirror([0,1,0]){ rotate([0,0,-alpha]){magnetA(dihedral,alpha,side2);}}	
    mirror([0,1,0]){ rotate([0,0,-alpha]){magnetB(dihedral,alpha,side2);}}
}

module chamfers(dihedral,alpha,beta,side2) {
    rotate([(180-dihedral)/2,0,alpha]){
        linear_extrude(center=true, height=thickness*10) {
            polygon([[-5,0],[-5,thickness],[side+5,thickness],[side+5,0]]);
        }
    }
    translate([side,0,0]){
        rotate([(-180+dihedral)/2,0,180-alpha]){
            translate([0,-thickness,0]){
                linear_extrude(center=true, height=thickness*10) { polygon([[-5,0],[-5,thickness],[side2,thickness],[side2,0]]); }
            }
        }
    }

    rotate([(-180+dihedral)/2,0,0]){
        translate([2.5,-thickness,0]){
            linear_extrude(center=true, height=thickness*10) { polygon([[-5,0],[-5,thickness],[side,thickness],[side,0]]); }
        }
    }

    translate([side*cos(alpha),side*sin(alpha),0]){
        mirror([0,1,0]){
            rotate([(-180+dihedral)/2,0,-180+alpha+beta]){
                translate([2.5,-thickness,0]){
                    linear_extrude(center=true, height=thickness*10) { polygon([[-5,0],[-5,thickness],[side2,thickness],[side2,0]]);}
                }
            }
        }
    }
}

module trigonal(){ //really a cube
    dihedral = 90;
    s = side; //a square, all sides are the same, all angles 90 degrees
    difference(){
        linear_extrude(height=thickness){
            polygon([[0,0],[s,0],[s,s],[0,s]]);
        }
        union(){
            chamfers(dihedral,90,90,s);
            magnets(dihedral,90,s);
        }
    }
    echo("Print 6 faces.");
}

module tetragonal(){
    dihedral = acos(-(2*sqrt(2)-1)/7);
    s1 = sqrt(sqrt(2)-1); //sides based on unit edge length square antiprism
    s2 = sqrt(2*(1+sqrt(2)))/2;
    side2 = s2*side/s1; //adjusted side based on user input
    A1 = 54.14143232789412; //acute interior angle of the kite
    A2 = 101.95285589070195; //all three other interior angles of the kite are the same
    difference(){
        linear_extrude(height=thickness){ polygon([[0,0],[side,0],[side+side2*cos(180-A2),side2*sin(180-A2)],[-side*cos(180-A2),side*sin(180-A2)]]); }
        union(){
            chamfers(dihedral,A2,A1,side2);
            magnets(dihedral,A2,side2);
        }
    }
    echo("Print 8 faces.");
}

module pentagonal(){
    dihedral = acos(-sqrt(5)/5);
    s1 = (sqrt(5)-1)/2;
    s2 = (1+sqrt(5))/2;
    side2 = s2*side/s1; //adjusted side based on user input
    A1 = 36; //acute interior angle of the kite
    A2 = 108; //all three other interior angles of the kite are the same
    difference(){
        linear_extrude(height=thickness){polygon([[0,0],[side,0],[side+side2*cos(180-A2),side2*sin(180-A2)],[-side*cos(180-A2),side*sin(180-A2)]]);}
        union() {
            chamfers(dihedral,A2,A1,side2);
            magnets(dihedral,A2,side2);
        }
    }
    echo("Print 10 faces.");
}

module hexagonal(){
    dihedral = acos(-sqrt(3)/3);
    s1 = sqrt(2*(sqrt(3)-1))/2;
    s2 = sqrt(2*(5+3*sqrt(3)))/2 ;
    side2 = s2*side/s1; //adjusted side based on user input
    A1 = 25.587895702680132; //acute interior angle of the kite
    A2 = 111.47070143243995; //all three other interior angles of the kite are the same
    difference(){
        linear_extrude(height=thickness){ polygon([[0,0],[side,0],[side+side2*cos(180-A2),side2*sin(180-A2)],[-side*cos(180-A2),side*sin(180-A2)]]);}
        union(){
            chamfers(dihedral,A2,A1,side2);
            magnets(dihedral,A2,side2);
        }
    }
    echo("Print 12 faces.");
}

module heptagonal(){
    dihedral = 132.017867361;
    s1 = 0.59740762289429270714;
    s2 = 3.0162617059937969890;
    side2 = s2*side/s1; //adjusted side based on user input
    A1 = 19.083716786371607; //acute interior angle of the kite
    A2 = 113.63876107120947; //all three other interior angles of the kite are the same
    difference(){
        linear_extrude(height=thickness){polygon([[0,0],[side,0],[side+side2*cos(180-A2),side2*sin(180-A2)],[-side*cos(180-A2),side*sin(180-A2)]]);}
        union(){
            chamfers(dihedral,A2,A1,side2);
            magnets(dihedral,A2,side2);
        }
    }
    echo("Print 14 faces.");
}

module octagonal(){
    dihedral = 137.370466429;
    s1 = sqrt(1-sqrt(2)+sqrt(2-sqrt(2)));
    s2 = sqrt(2*(8+5*sqrt(2)+sqrt(2*(58+41*sqrt(2)))))/2 ;
    side2 = s2*side/s1; //adjusted side based on user input
    A1 = 14.76071381173551; //acute interior angle of the kite
    A2 = 115.07976206275484; //all three other interior angles of the kite are the same
    difference(){
        linear_extrude(height=thickness){ polygon([[0,0],[side,0],[side+side2*cos(180-A2),side2*sin(180-A2)],[-side*cos(180-A2),side*sin(180-A2)]]);}
        union(){
            chamfers(dihedral,A2,A1,side2);
            magnets(dihedral,A2,side2);
        }
    }
    echo("Print 16 faces.");
}

