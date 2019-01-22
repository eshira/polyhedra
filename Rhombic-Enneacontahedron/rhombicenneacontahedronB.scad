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
//BLUE tile (the ones that meet in 5s)

//User Defined Variables
side = 20; //side length, these match to red side length
thickness = 8;//46.0851; //how thick (z dimension) the tile is
magnetdepth = 2.25; //depth of the magnet holes; tailor this to suit your 3d printer
magnetdiam = 3.45; //diameter of the magnet holes; tailor this to suit your 3d printer

//Other Variables
dihedral = 160.81186354627906; //the dihedral angle
dihedral2 = 159.4455573432933; //the other dihedral angle
alpha = 56.67993474152847; //Rhombus acute angle
beta=69.73165195317623;
short = side*0.36037602329028573/0.4339800705873414;
phi=90-(69.73165195317623/2);
phi2=90-(56.679934741528456/2);
obtuse = 116.7942066526477; //obtuse interior angle
sdiag = 2*short*sin(beta/2);
l1 = 2*side*cos(alpha/2);
l2 = short*cos(beta/2);
ldiag =  l1+l2;

//Main
 tile();
translate([-2,-2,0]) rotate([0,0,70]) tile();
translate([-1,-2,0]) rotate([0,0,-70]) tile();
translate([-2,-4,0]) rotate([0,0,140]) tile();
translate([-1,-4,0]) rotate([0,0,-140]) tile();

//Modules


module tile() {
    difference(){
        rotate([0,0,beta/2-90]) {
            difference(){
                mainbody();
                chamfers();
            }
        }
        magnets();
    }
}

module magnet2() {
	t_h = 0.5*side*cos(90-alpha)*(sin(0.5*dihedral2)/sin(90-0.5*dihedral2));
    
    fac=(1/3);
    mx = short+fac*side*cos(180-obtuse);
    my = fac*side*sin(180-obtuse);
    
    mx2 = short+(1-fac)*side*cos(180-obtuse);
    my2 = (1-fac)*side*sin(180-obtuse);
        
    ptr = 0.5*thickness/t_h;
	extra=.1;

	translate([mx*(1-ptr)+l2*cos(beta/2)*ptr,(1-ptr)*my+l2*sin(beta/2)*ptr,t_h*ptr]){
		rotate([180-dihedral2/2,0,-obtuse]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}
    translate([mx2*(1-ptr)+l2*cos(beta/2)*ptr,(1-ptr)*my2+l2*sin(beta/2)*ptr,t_h*ptr]){
		rotate([180-dihedral2/2,0,-obtuse]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}
}


module magnet1() {
//	//height of the virtual 'point' of the tile
    t_h = 0.5*side*cos(90-alpha)*(sin(0.5*dihedral2)/sin(90-0.5*dihedral2));
    
    //echo(t_h);
	//translate([l2*cos(beta/2),l2*sin(beta/2),t_h]) sphere(r=1);
    
    // (If the thickness of the tile is greater than t_h, then instead of a top flat face, the tile is pyramidal)
	//Now we create a parameter in the range [0,1] representing the magnet hole height as a portion of t_h
	ptr = 0.5*thickness/t_h;
	extra=.1;
	//Place the magnet in the exact middle of the face; mix movement along long diagonal with movement along side, weighed by ptr
    portion = (1/3);
	translate([l2*cos(beta/2)*ptr+(1-ptr)*short*(portion),l2*sin(beta/2)*ptr,t_h*ptr]){
		rotate([-180+dihedral/2,0,0]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}
	translate([l2*cos(beta/2)*ptr+(1-ptr)*short*(1-portion),l2*sin(beta/2)*ptr,t_h*ptr]){
		rotate([-180+dihedral/2,0,0]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}
}

module mainbody(){
	linear_extrude(height = thickness ) {
		translate([0,short*sin(phi),0]) polygon([[0,-short*sin(phi)],[short*cos(phi),0],[0,side*sin(phi2)],[-short*cos(phi),0]]);
	}
}

module chamfers() {
    translate([0,short*sin(phi)+side*sin(phi2),0]) {
        rotate([90-dihedral2/2,0,-phi2]){
        linear_extrude(center=true, height=thickness*10) {
            polygon([[-5,0],[-5,thickness],[side+5,thickness],[side+5,0]]);
            }
        }   
    }
    mirror([1,0,0]){
    translate([0,short*sin(phi)+side*sin(phi2),0]) {
        rotate([90-dihedral2/2,0,-phi2]){
        linear_extrude(center=true, height=thickness*10) {
            polygon([[-5,0],[-5,thickness],[side+5,thickness],[side+5,0]]);
            }
        }   
    }    
}

    rotate([-90+dihedral/2,0,phi]){
        linear_extrude(center=true, height=thickness*10) {
            translate([0,-thickness,0]) polygon([[-5,0],[-5,thickness],[side+5,thickness],[side+5,0]]);
        }
    }
    mirror([1,0,0]){
        rotate([-90+dihedral/2,0,phi]){
            linear_extrude(center=true, height=thickness*10) {
            translate([0,-thickness,0]) polygon([[-5,0],[-5,thickness],[side+5,thickness],[side+5,0]]);
        }
    }
    }
}




module magnets() {
    magnet1();
    rotate([0,0,beta]) mirror([0,1,0]) magnet1();
    magnet2();
    rotate([0,0,beta]) mirror([0,1,0]) magnet2();
}