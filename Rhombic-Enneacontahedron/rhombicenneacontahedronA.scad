/*
	Rhombic Enneacontahedron with magnets, tile A
    by eshira

    Values computed by the accompanying python script
    red to blue 159.4455573432933
    blue to blue 160.81186354627906
    -----------------
    Interior angle1 for red faces:
    56.67993474152847

    Interior angle2 for red faces:
    123.32006525847153

    --------------
    Interior angle1a for blue faces:
    69.73165195317623
    Interior angle1b for blue faces:
    56.679934741528456

    Interior angle2 for blue faces:
    116.79420665264766
    116.79420665264769 (these two are the same, rounding error?)
    ----------

    long side distance for blue faces:
    0.4339800705873414
    short side distance for blue faces:
    0.36037602329028573
*/

$fn=50;
//RED tile (the ones that meet in 3s)

//User Defined Variables
side = 20; //side length (all sides are equal length)
thickness = 8; //how thick (z dimension) the tile is
magnetdepth = 2.25; //depth of the magnet holes; tailor this to suit your 3d printer
magnetdiam = 3.45; //diameter of the magnet holes; tailor this to suit your 3d printer

//Other Variables
dihedral = 159.4455573432933; //the dihedral angle
alpha = 56.67993474152847; //Rhombus acute angle

//Main
space=2;
translate([space,space,0]) tile();
translate([space/2,space,0]) rotate([0,0,60]) tile();
translate([0,space,0]) rotate([0,0,120]) tile();
translate([space,space/2,0]) rotate([0,0,-60]) tile();
translate([space/2,space/2,0]) rotate([0,0,-120]) tile();
translate([0,space/2,0]) rotate([0,0,-180]) tile();


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
	
    portion=(1/3);
    mx=portion*side*cos(alpha);
    my=portion*side*sin(alpha);
    mx2=(1-portion)*side*cos(alpha);
    my2=(1-portion)*side*sin(alpha);
    
    translate([(1-ptr)*mx+ptr*0.5*ldiag*cos(alpha/2),(1-ptr)*my+ptr*0.5*ldiag*sin(alpha/2),t_h*ptr]){
		rotate([180-dihedral/2,0,alpha]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}
    translate([(1-ptr)*mx2+ptr*0.5*ldiag*cos(alpha/2),(1-ptr)*my2+ptr*0.5*ldiag*sin(alpha/2),t_h*ptr]){
		rotate([180-dihedral/2,0,alpha]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}
}

module magnet2() {
	ldiag = side*(sin(180-alpha)/sin(alpha/2)); // the long diagonal of the rhombus
	t_h = 0.5*side*cos(90-alpha)*(sin(0.5*dihedral)/sin(90-0.5*dihedral)); //height of the virtual 'point' of the tile
	// (If the thickness of the tile is greater than t_h, then instead of a top flat face, the tile is pyramidal)
	//Now we create a parameter in the range [0,1] representing the magnet hole height as a portion of t_h
	ptr = 0.5*thickness/t_h;
	extra=.1;
	//Place the magnet in the exact middle of the face; mix movement along long diagonal with movement along side, weighed by ptr
	
    portion=(1/3);
    mx=side*cos(alpha)+portion*side;
    my=side*sin(alpha);
    mx2=side*cos(alpha)+(1-portion)*side;
    my2=side*sin(alpha);
    
    translate([(1-ptr)*mx+ptr*0.5*ldiag*cos(alpha/2),(1-ptr)*my+ptr*0.5*ldiag*sin(alpha/2),t_h*ptr]){
		rotate([180-dihedral/2,0,0]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}
    translate([(1-ptr)*mx2+ptr*0.5*ldiag*cos(alpha/2),(1-ptr)*my2+ptr*0.5*ldiag*sin(alpha/2),t_h*ptr]){
		rotate([180-dihedral/2,0,0]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}
}

module magnets() {
    magnet1();
    mirror([0,1,0]) rotate([0,0,-alpha]) magnet1();
    magnet2();
    mirror([0,1,0]) rotate([0,0,-alpha]) magnet2();
}