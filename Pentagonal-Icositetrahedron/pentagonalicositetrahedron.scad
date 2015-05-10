/*
	Pentagonal icositetrahedron with magnets tile, by eshira
	Dihedral angle: 136.3092°
	Pentagonal angles: 114.812° (4), 80.7517° (1)
	This shape has a chirality (left/right handedness)
	To make the other enantiomorph, take the mirror of this tile instead
	
	This work is licensed under the Creative Commons Attribution 4.0 International License.
	To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/.
	
	24 tiles total are required.
	Use axially aligned magnets (4 per tile).
	Magnet mounting per tile MUST BE IDENTICAL!
	Following the following constraints:
		-The two long sides of the pentagon should have opposite poles facing outward
		-The two short sides with holes should have opposite poles facing outward

	For example, you could do N - S - N - S going around the pentagon, skipping the empty face.

*/

$fn=50;

//User Defined Variables
longside = 40; //long side length of the pentagon
thickness = 10; //how thick (z dimension) the tile is
magnetdepth = 2.5; //depth of the magnet holes; tailor this to suit your 3d printer
magnetdiam = 6.5; //diameter of the magnet holes; tailor this to suit your 3d printer

//Other Variables
dihedral = 136.3092; //the dihedral angle
alpha = 80.7517; //pentagon small inner angle (1)
beta = 114.812; //pentagon large inner angle (4)
b = sin(alpha/2)*longside;
a = cos(alpha/2)*longside;
gamma = asin(a/longside);
shortside = 2*b/(1+2*cos(beta-gamma)); //short side length of pentagon
c = sin(beta-gamma)*shortside;
d = thickness/tan(dihedral/2);
e = sin(180-beta)*thickness;
f = sqrt(thickness*thickness-e*e);
excess = 15;


//Main Code
difference(){
	mainbody();
		union(){
		chamfers();
		magnets();
	}
}


//Modules
module mainbody(){
	linear_extrude(height = thickness ) {
		polygon([[0,0],[+b,-a],[shortside/2,-a-c],[-shortside/2,-a-c],[-b,-a]]);
	}
}

module chamfers() {
	rotate([(180-dihedral)/2,0,-90+alpha/2]){
		linear_extrude(center=true, height=25) {
			polygon([[-5,0],[-5,thickness],[longside+5,thickness],[longside+5,0]]);
		}
	}

	mirror([1,0,0]){
		rotate([(180-dihedral)/2,0,-90+alpha/2]){
			linear_extrude(center=true, height=25) {
				polygon([[-5,0],[-5,thickness],[longside+5,thickness],[longside+5,0]]);
			}
		}
	}

	translate([(shortside/2),-a-c,0]){
		rotate([(-180+dihedral)/2,0,180-beta]){
			translate([0,-thickness,0]){
				linear_extrude(center=true, height=25) {
					polygon([[-5,0],[-5,thickness],[shortside,thickness],[shortside,0]]);
				}
			}
		}
	}

	mirror([1,0,0]){
		translate([(shortside/2),-a-c,0]){
			rotate([(-180+dihedral)/2,0,180-beta]){
				translate([0,-thickness,0]){
					linear_extrude(center=true, height=25) {
						polygon([[-5,0],[-5,thickness],[shortside,thickness],[shortside,0]]);
					}
				}
			}
		}
	}

	translate([0,-a-c,0]){
		rotate([(-180+dihedral)/2,0,0]){
			linear_extrude(center=true, height=25) {
				polygon([[-shortside/2,-thickness],[shortside/2,-thickness],[shortside/2,0],[-shortside/2,0]]);
			}
		}
	}
}

module magnets() {
	rotate([-dihedral/2,0,-90+alpha/2]){
		translate([longside/2,-thickness/2,-magnetdepth+0.2]){
			linear_extrude(center=false, height=magnetdepth+0.2) {
				circle(magnetdiam/2);
			}
		}
	}

	mirror([1,0,0]){
		rotate([-dihedral/2,0,-90+alpha/2]){
			translate([longside/2,-thickness/2,-magnetdepth+0.2]){
				linear_extrude(center=false, height=magnetdepth+0.2) {
					circle(magnetdiam/2);
				}
			}
		}
	}

	translate([(shortside/2),-a-c,0]){
		rotate([(-180+dihedral)/2,0,180-beta]){
			rotate([-90,0,0]) {
				translate([shortside/2,-thickness/2,-.2]){
					linear_extrude(center=false, height=magnetdepth+0.2) {
						circle(magnetdiam/2);
					}
				}
			}
		}
	}

	translate([0,-a-c,0]){
		rotate([(-180+dihedral)/2,0,0]){
			translate([0,magnetdepth-.2,thickness/2]){
				rotate([90,0,0]){
					linear_extrude(center=false, height=magnetdepth+0.2) {
						circle(magnetdiam/2);
					}
				}
			}
		}
	}
}

