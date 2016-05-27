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

module magnets() {
    extra=.2;
    rotate([0,0,alpha]) {
        translate([side/2,-0.5*(thickness)*cos(dihedral/2)-magnetdepth/sin(dihedral/2),thickness/2]){
            rotate([-dihedral/2,0,0]){
                linear_extrude(center=false, height=magnetdepth+extra) {
                    circle(magnetdiam/2);
                }
            }
        }
    }
    rotate([0,0,0]) {
        translate([side/2,0.5*thickness*cos(dihedral/2)+magnetdepth/sin(dihedral/2),thickness/2]){
            rotate([dihedral/2,0,0]){
                linear_extrude(center=false, height=magnetdepth+extra) {
                    circle(magnetdiam/2);
                }
            }
        }
    }

    translate([side+side*cos(alpha),side*sin(alpha),0]) {
        rotate([0,0,180]) {
            rotate([0,0,alpha]) {
                translate([side/2,-0.5*(thickness)*cos(dihedral/2)-magnetdepth/sin(dihedral/2),thickness/2]){
                    rotate([-dihedral/2,0,0]){
                        linear_extrude(center=false, height=magnetdepth+extra) {
                            circle(magnetdiam/2);
                        }
                    }
                }
            }
            rotate([0,0,0]) {
                translate([side/2,0.5*thickness*cos(dihedral/2)+magnetdepth/sin(dihedral/2),thickness/2]){
                    rotate([dihedral/2,0,0]){
                        linear_extrude(center=false, height=magnetdepth+extra) {
                            circle(magnetdiam/2);
                        }
                    }
                }
            }
        }
    }    
}
