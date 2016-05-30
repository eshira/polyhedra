/*
	Deltoidal icositetrahedron with magnets tile, by eshira
	Dihedral angle: 138° 7' 5"
	
	24 tiles total are required.
	Use axially aligned magnets (4 per tile).
	Magnet mounting per tile MUST BE IDENTICAL!
	Following the following constraints:
		-Two parallel sides have the same pole facing outward
		-Two adjacent sides have the opposite pole facing outward
    See the diagram included for more help.

*/

$fn=50;

//User Defined Variables
longside = 40; //side length for shorter side
thickness = 10; //how thick (z dimension) the tile is
magnetdepth = 2.5; //depth of the magnet holes; tailor this to suit your 3d printer
magnetdiam = 6.5; //diameter of the magnet holes; tailor this to suit your 3d printer

//Other Variables
dihedral = acos(-(7+4*sqrt(2))/17); //dihedral angle
shortside = longside*(4+sqrt(2))/7; //short side of kite
ldiag = (longside/7)*sqrt(46+15*sqrt(2)); //Long diagonal of kite
theta = asin((sqrt(29-2*sqrt(2)))/(2*(4-sqrt(2)))); //Angle between long and short sides
phi = asin(longside*sin(theta)/ldiag); // Half the angle between the two short sides

difference(){
    mainbody();
    chamfers();
}
//Main
//tile();

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
