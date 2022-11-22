/*
	Rhombic Enneacontahedron with magnets
    by eshira
*/

$fn=50;

//User Defined Variables
side = 30; //side length, these match to red side length
thickness = 20;//46.0851; //how thick (z dimension) the tile is
magnetdepth = 2.25; //depth of the magnet holes; tailor this to suit your 3d printer
magnetdiam = 4; //diameter of the magnet holes; tailor this to suit your 3d printer

//Other Variables - Get from python script
dihedral2= 161.0021166134344 ;
dihedral= 156.37057122706983 ;
alpha= 77.94689467373131 ;
beta= 68.51275396217996 ;
blue1b= 36.65885970094695 ;
obtuse= 127.41419316843655 ;
sidefactor= 0.5586814777741947 ;

short = side*sidefactor;
phi=90-(beta/2);
phi2=90-(blue1b/2);
sdiag = 2*short*sin(beta/2);
l1 = 2*side*cos(alpha/2);
l2 = short*cos(beta/2);
ldiag =  l1+l2;

/*--------Choose what to render here----------*/
//tile_B is a BLUE tile (the ones that meet in 5s forming a star)
//tile_B();

//tile_A is a red tile. These shared edges with only blue tiles (never themselves)
//tile_A();

//Unit shows an assembly of three blue tiles and three red tiles
//(note I still have one angle to calculate to make it fold up right)
unit(); 


/*--------------------------------------*/

module unit(){
mirror([1,0,0]) rotate([0,-(180-dihedral2),alpha/2]) { translate([short*sin(180-obtuse),-side-short*cos(180-obtuse),0]) rotate([0,0,90-obtuse])  mirror([1,0,0]) tile_B();
rotate([180-dihedral2,0,-90+blue1b])  tile_A();}

rotate([0,-(180-dihedral2),alpha/2]){ translate([short*sin(180-obtuse),-side-short*cos(180-obtuse),0]) rotate([0,0,90-obtuse])  mirror([1,0,0]) tile_B();
rotate([180-dihedral2,0,-90+blue1b])  tile_A();}
rotate([0,0,-90-alpha/2]) tile_A();


//figure out this "38" later
rotate([38,0,0]) rotate([0,0,180-blue1b/2]) translate([short*sin(180-obtuse),-side-short*cos(180-obtuse),0]) rotate([0,0,90-obtuse])  mirror([1,0,0]) tile_B();
}

module tile_B(){
    tile();}

module tile_A(){
rotate([0,0,90+alpha/2]){
tile_A_half();
translate([0,-2*side*cos(alpha/2),0]) mirror([0,1,0]) tile_A_half();    
}}
module tile_A_half(){
    difference()
{
difference(){
rotate([0,-(180-dihedral2),alpha/2]) union(){
rotate([0,0,blue1b])    mirror([1,0,0]) test2();
}

union(){
mirror([1,0,0]) rotate([0,-(180-dihedral2),alpha/2]) union(){
test1();
}
rotate([0,-(180-dihedral2),alpha/2]) union(){
test1();
}
}
}

translate([-side*1.5,-side*3-side*cos(alpha/2),-1.5*thickness])    cube([side*3,side*3,thickness*3]);
}
}
module test1(){
    union(){
//translate([short*sin(180-obtuse),-side-short*cos(180-obtuse),0])  //rotate([0,0,90-obtuse])  mirror([1,0,0]) tile();
rotate([180-dihedral2,0,-90+blue1b])  tileA();
}}
module test2(){
    union(){
//translate([short*sin(180-obtuse),-side-short*cos(180-obtuse),0])  rotate([0,0,90-obtuse])  mirror([1,0,0]) tile();
rotate([180-dihedral2,0,-90+blue1b])  tileA();
}}
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
    portion = (1/2);
	translate([l2*cos(beta/2)*ptr+(1-ptr)*short*(portion),l2*sin(beta/2)*ptr,t_h*ptr]){
		rotate([-180+dihedral/2,0,0]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}
	/*translate([l2*cos(beta/2)*ptr+(1-ptr)*short*(1-portion),l2*sin(beta/2)*ptr,t_h*ptr]){
		rotate([-180+dihedral/2,0,0]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}*/
}

module mainbody(){
	linear_extrude(height = thickness ) {
		translate([0,short*sin(phi),0]) polygon([[0,-short*sin(phi)],[short*cos(phi),0],[0,side*sin(phi2)],[-short*cos(phi),0]]);
	}
}

module chamfers() {
    translate([0,short*sin(phi)+side*sin(phi2),0]) {
        rotate([90-(dihedral2/2),0,-phi2]){
        linear_extrude(center=true, height=thickness*10) {
            polygon([[-5,0],[-5,thickness],[side+5,thickness],[side+5,0]]);
            }
        }   
    }
    mirror([1,0,0]){
    translate([0,short*sin(phi)+side*sin(phi2),0]) {
        rotate([90-(dihedral2/2),0,-phi2]){
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


//Main
//rotate([180-dihedral2,0,0]) tile();
//rotate([180-dihedral2,0,0])  
//magnets();
//translate([-10.2,-13.3,0]) rotate([0,0,232.5]) mirror([1,0,0]) import("tileB.stl");

//Modules

module tileA() {
   difference(){
        mainbodyA();
        union(){
            chamfersA();
            magnetsA();
        }
    }
    
}


module mainbodyA(){
	linear_extrude(height = thickness ) {
		polygon([[0,0],[side,0],[side+side*cos(alpha),side*sin(alpha)],[side*cos(alpha),side*sin(alpha)]]);
	}
}

module chamfersA() {
    test=90-(dihedral2/2);
    rotate([test,0,alpha]){
		mirror([0,0,0]) linear_extrude(center=true, height=thickness*10) {
			polygon([[-5,0],[-5,thickness],[side+5,thickness],[side+5,0]]);
		}
	}

	translate([side,0,0]){
		rotate([(90+(dihedral2/2)),0,alpha]){
			mirror([0,1,0]) translate([0,-thickness,0]){
				linear_extrude(center=true, height=thickness*10) {
					polygon([[-5,0],[-5,thickness],[side,thickness],[side,0]]);
				}
			}
		}
	}
  
	rotate([(90+(dihedral2/2)),0,0]){
		mirror([0,1,0]) translate([0,-thickness,0]){
			linear_extrude(center=true, height=thickness*10) {
				polygon([[-5,0],[-5,thickness],[side,thickness],[side,0]]);
			}
		}
	}
    
    
    translate([side*cos(alpha),side*sin(alpha),0]){
       
            rotate([test,0,0]){
                mirror([0,1,0]){translate([0,-thickness,0]){
                    linear_extrude(center=true, height=thickness*10) {
                        polygon([[-5,0],[-5,thickness],[side,thickness],[side,0]]);
                    }
                }
			}
		}
	}
   
}

module magnet1A() {
	ldiag = side*(sin(180-alpha)/sin(alpha/2)); // the long diagonal of the rhombus
	t_h = 0.5*side*cos(90-alpha)*(sin(0.5*dihedral2)/sin(90-0.5*dihedral2)); //height of the virtual 'point' of the tile
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
		rotate([180-(dihedral2/2),0,alpha]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}
    translate([(1-ptr)*mx2+ptr*0.5*ldiag*cos(alpha/2),(1-ptr)*my2+ptr*0.5*ldiag*sin(alpha/2),t_h*ptr]){
		rotate([180-(dihedral2/2),0,alpha]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}
}

module magnet2A() {
	ldiag = side*(sin(180-alpha)/sin(alpha/2)); // the long diagonal of the rhombus
	t_h = 0.5*side*cos(90-alpha)*(sin(0.5*dihedral2)/sin(90-0.5*dihedral2)); //height of the virtual 'point' of the tile
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
		rotate([180-(dihedral2/2),0,0]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}
    translate([(1-ptr)*mx2+ptr*0.5*ldiag*cos(alpha/2),(1-ptr)*my2+ptr*0.5*ldiag*sin(alpha/2),t_h*ptr]){
		rotate([180-(dihedral2/2),0,0]){
			translate([0,0,-extra]){
				linear_extrude(center=false,height=magnetdepth){ circle(magnetdiam/2);}
			}
		}
	}
}

module magnetsA() {
    magnet1A();
    mirror([0,1,0]) rotate([0,0,-alpha]) magnet1A();
    magnet2A();
    mirror([0,1,0]) rotate([0,-0,-alpha]) magnet2A();
}