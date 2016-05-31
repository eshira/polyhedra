/*
	Deltoidal hexecontahedron with magnets tile, by eshira
	Dihedral angle: 154.12°
	
	60 tiles total are required.
	Use axially aligned magnets (4 per tile).
	Magnet mounting per tile MUST BE IDENTICAL!
	Following the following constraints:
		-Two parallel sides have the same pole facing outward
		-Two adjacent sides have the opposite pole facing outward
    See the diagram included for more help.

*/

$fn=50;

//User Defined Variables
longside = 40; //side length for longer side
thickness = 10; //how thick (z dimension) the tile is
magnetdepth = 2.5; //depth of the magnet holes; tailor this to suit your 3d printer
magnetdiam = 6.5; //diameter of the magnet holes; tailor this to suit your 3d printer

//Other Variables
dihedral = 154.12; //dihedral angle
phi = 118.22/2; // Half the angle between the two short sides
theta = 87.01; //Angle between long and short sides
shortside = longside*6/(7+sqrt(5)); //short side to long side ratio is 6:(7+√5)
ldiag = longside*sin(theta)/sin(phi); //Long diagonal of kite

//Main
tile();

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
        polygon([[0,0],[-shortside*cos(90-phi),shortside*sin(90-phi)],[0,ldiag],[shortside*cos(90-phi),shortside*sin(90-phi)]]);
	}
}

module chamfers() {
	rotate([(180-dihedral)/2,0,phi+90]){
		linear_extrude(center=true, height=thickness*10) {
			polygon([[-5,0],[-5,thickness],[shortside+5,thickness],[shortside+5,0]]);
		}
	}
    
    mirror([1,0,0]){
        rotate([(180-dihedral)/2,0,phi+90]){
            linear_extrude(center=true, height=thickness*10) {
                polygon([[-5,0],[-5,thickness],[shortside+5,thickness],[shortside+5,0]]);
            }
        }
    }
    translate([0,ldiag,0]){
    	rotate([(180-dihedral)/2,0,-phi-theta+90]){
            linear_extrude(center=true, height=thickness*10) {
                polygon([[-5,0],[-5,thickness],[longside+5,thickness],[longside+5,0]]);
            }
        }
    }
    
    mirror([1,0,0]){
        translate([0,ldiag,0]){
            rotate([(180-dihedral)/2,0,-phi-theta+90]){
                linear_extrude(center=true, height=thickness*10) {
                    polygon([[-5,0],[-5,thickness],[longside+5,thickness],[longside+5,0]]);
                }
            }
        }
    }
}

module magnets() {
    extra=0.1;
    
    translate([-0.5*shortside*cos(90-phi),0.5*shortside*sin(90-phi),0]){
        rotate([180-dihedral/2,0,phi+90]){
            translate([0,thickness/2,-extra]) {
                linear_extrude(center=false, height=magnetdepth) {
                    circle(magnetdiam/2);
                }
            }
        }
    }
    
    mirror([1,0,0]){
        translate([-0.5*shortside*cos(90-phi),0.5*shortside*sin(90-phi),0]){
            rotate([180-dihedral/2,0,phi+90]){
                translate([0,thickness/2,-extra]) {
                    linear_extrude(center=false, height=magnetdepth) {
                        circle(magnetdiam/2);
                    }
                }
            }
        }
    }
    
    mirror([0,0,0]){
        translate([0.5*longside*cos(theta-(180-2*phi)/2),0.5*longside*sin(theta-(180-2*phi)/2)+shortside*sin(90-phi),0]){
            rotate([180-dihedral/2,0,-90+theta/2]){
                translate([0,thickness/2,-extra]) {
                    linear_extrude(center=false, height=magnetdepth) {
                        circle(magnetdiam/2);
                    }
                }
            }
        }
    }    
    
    mirror([1,0,0]){
        translate([0.5*longside*cos(theta-(180-2*phi)/2),0.5*longside*sin(theta-(180-2*phi)/2)+shortside*sin(90-phi),0]){
            rotate([180-dihedral/2,0,-90+theta/2]){
                translate([0,thickness/2,-extra]) {
                    linear_extrude(center=false, height=magnetdepth) {
                        circle(magnetdiam/2);
                    }
                }
            }
        }
    } 
}