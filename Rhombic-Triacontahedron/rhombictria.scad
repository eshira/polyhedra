/*
	Rhombic Triacontahedron with magnets tile, by eshira
	Dihedral angle: 144°
	Rhombic angles: 
	
	30 tiles total are required.
	Use axially aligned magnets (4 per tile).
	Magnet mounting per tile MUST BE IDENTICAL!
	Following the following constraints:
		-Two parallel sides have the same pole facing outward
		-Two adjacent sides have the opposite pole facing outward
    See the diagram included for more help.

*/

$fn=50;

//User Defined Variables
side = 40; //side length (all sides are equal length)
thickness = 10; //how thick (z dimension) the tile is
magnetdepth = 2.5; //depth of the magnet holes; tailor this to suit your 3d printer
magnetdiam = 6.5; //diameter of the magnet holes; tailor this to suit your 3d printer

//Other Variables
dihedral = 144; //the dihedral angle
alpha = atan(2); //Rhombus acute angle

//Main
tile();
//rotate([dihedral/4,0,alpha]){tile();} //Show a second tile rotated to correct relative position
//rotate([-dihedral/4,0,0]){ rotate([0,0,-alpha]){tile();}} //Show a third tile rotated to correct relative position

//Modules

module tile() {
    difference(){
        mainbody();
        union(){
            chamfers();
            magnets();
        }
    }
}

module mainbody(){
	linear_extrude(height = thickness ) {
		polygon([[0,0],[side,0],[side+side*cos(alpha),side*sin(alpha)],[side*cos(alpha),side*sin(alpha)]]);
	}
}

module chamfers() {
	rotate([(180-dihedral)/2,0,alpha]){
		linear_extrude(center=true, height=thickness*10) {
			polygon([[-5,0],[-5,thickness],[side+5,thickness],[side+5,0]]);
		}
	}

	translate([side,0,0]){
		rotate([(-180+dihedral)/2,0,alpha]){
			translate([0,-thickness,0]){
				linear_extrude(center=true, height=thickness*10) {
					polygon([[-5,0],[-5,thickness],[side,thickness],[side,0]]);
				}
			}
		}
	}
    
	rotate([(-180+dihedral)/2,0,0]){
		translate([0,-thickness,0]){
			linear_extrude(center=true, height=thickness*10) {
				polygon([[-5,0],[-5,thickness],[side,thickness],[side,0]]);
			}
		}
	}
    translate([side*cos(alpha),side*sin(alpha),0]){
        mirror([0,1,0]){
            rotate([(-180+dihedral)/2,0,0]){
                translate([0,-thickness,0]){
                    linear_extrude(center=true, height=thickness*10) {
                        polygon([[-5,0],[-5,thickness],[side,thickness],[side,0]]);
                    }
                }
			}
		}
	}
}

module magnet1() {
	ldiag = side*(sin(180-alpha)/sin(alpha/2)); // the long diagonal of the rhombus
	t_h = 0.5*side*cos(90-alpha)*(sin(0.5*dihedral)/sin(90-0.5*dihedral)); //height of the virtual 'point' of the tile
	// (If the thickness of the tile is greater than t_h, then instead of a top flat face, the tile is pyramidal)
	//Now we create a parameter in the range [0,1] representing the magnet hole height as a portion of t_h
	ptr = 0.5*thickness/t_h;
	extra=.1;
	//Place the magnet in the exact middle of the face; mix movement along long diagonal with movement along side, weighed by ptr
	translate([ptr*0.5*ldiag*cos(alpha/2)+0.5*(1-ptr)*side*cos(alpha),ptr*0.5*ldiag*sin(alpha/2)+0.5*(1-ptr)*side*sin(alpha),0.5*thickness]){
		rotate([180-dihedral/2,0,alpha]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}
}

module magnet2() {
	sdiag = side*(sin(alpha)/sin(90-0.5*alpha)); //short diagonal of the rhombus
	t_h = 0.5*side*cos(90-alpha)*(sin(0.5*dihedral)/sin(90-0.5*dihedral)); //height of the virtual 'point' of the tile
	// (If the thickness of the tile is greater than t_h, then instead of a top flat face, the tile is pyramidal)
	//Now we create a parameter in the range [0,1] representing the magnet hole height as a portion of t_h
	ptr = 0.5*thickness/t_h;
	extra=.1;
	//Place the magnet in the exact middle of the face; mix movement along short diagonal with movement along side, weighed by ptr

	translate([side-ptr*0.5*sdiag*cos(90-0.5*alpha)+0.5*(1-ptr)*side*cos(alpha),ptr*0.5*sdiag*sin(90-0.5*alpha)+0.5*(1-ptr)*side*sin(alpha),thickness/2]){
		rotate([180-dihedral/2,0,180+alpha]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}
}

module magnets() {
	magnet1();
	mirror([0,1,0]){ rotate([0,0,-alpha]){magnet1();}}	
	magnet2();
	mirror([0,1,0]){ rotate([0,0,-alpha]){magnet2();}}
}