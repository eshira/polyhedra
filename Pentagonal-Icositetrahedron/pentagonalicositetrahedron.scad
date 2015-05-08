//Pentagonal icositetrahedron with magnets

//Dihedral angle: 136.3092°
//big angle (times 4), 114.812°, smallangle x1 80.7517°
$fn=50;

//to do put in my diagram

longside = 40; //long side -- this is the only parameter needed to define our pentagon
thickness = 10; //how thick our piece is

magnetdepth = 2.5;
magnetdiam = 6.5;

dihedral = 136.3092; //the dihedral angle of our thing is fixed
alpha = 80.7517; //the small angle of the point
beta = 114.812; //the larger angle between the other points


b = sin(alpha/2)*longside;
a = cos(alpha/2)*longside;

gamma = asin(a/longside);

shortside = 2*b/(1+2*cos(beta-gamma));

c = sin(beta-gamma)*shortside;

d = thickness/tan(dihedral/2);

e = sin(180-beta)*thickness;
f = sqrt(thickness*thickness-e*e);

excess = 15;

module mainbody(){
linear_extrude(height = thickness ) {
polygon([[0,0],[+b,-a],[shortside/2,-a-c],[-shortside/2,-a-c],[-b,-a]]);
}}

module chamfers() {
rotate([(180-dihedral)/2,0,-90+alpha/2]){
linear_extrude(center=true, height=25) {
polygon([[-5,0],[-5,thickness],[longside+5,thickness],[longside+5,0]]);
}}

mirror([1,0,0]){
rotate([(180-dihedral)/2,0,-90+alpha/2]){
linear_extrude(center=true, height=25) {
polygon([[-5,0],[-5,thickness],[longside+5,thickness],[longside+5,0]]);
}}}

translate([(shortside/2),-a-c,0]){
rotate([(-180+dihedral)/2,0,180-beta]){
translate([0,-thickness,0]){
linear_extrude(center=true, height=25) {
polygon([[-5,0],[-5,thickness],[shortside,thickness],[shortside,0]]);
}}}}

mirror([1,0,0]){
translate([(shortside/2),-a-c,0]){
rotate([(-180+dihedral)/2,0,180-beta]){
translate([0,-thickness,0]){
linear_extrude(center=true, height=25) {
polygon([[-5,0],[-5,thickness],[shortside,thickness],[shortside,0]]);
}}}}}


translate([0,-a-c,0]){
rotate([(-180+dihedral)/2,0,0]){
linear_extrude(center=true, height=25) {
polygon([[-shortside/2,-thickness],[shortside/2,-thickness],[shortside/2,0],[-shortside/2,0]]);
}}}

}

module magnets() {

//MAGNETS
rotate([-dihedral/2,0,-90+alpha/2]){
translate([longside/2,-thickness/2,-magnetdepth+0.2]){
linear_extrude(center=false, height=magnetdepth+0.2) {
circle(magnetdiam/2);
}}}



mirror([1,0,0]){
rotate([-dihedral/2,0,-90+alpha/2]){
translate([longside/2,-thickness/2,-magnetdepth+0.2]){
linear_extrude(center=false, height=magnetdepth+0.2) {
circle(magnetdiam/2);
}}}}


translate([(shortside/2),-a-c,0]){
rotate([(-180+dihedral)/2,0,180-beta]){
rotate([-90,0,0]){//90-dihedral
translate([shortside/2,-thickness/2,-.2]){
linear_extrude(center=false, height=magnetdepth+0.2) {
circle(magnetdiam/2);
}}}
}}

/*mirror([1,0,0]){
translate([(shortside/2),-a-c,0]){
rotate([(-180+dihedral)/2,0,180-beta]){
rotate([-90,0,0]){//90-dihedral
translate([shortside/2,-thickness/2,-.2]){
linear_extrude(center=false, height=magnetdepth+0.2) {
circle(magnetdiam/2);
}}}
}}}*/ //this magnet removed, or replace it and remove the other for the other enantiomorph

translate([0,-a-c,0]){
rotate([(-180+dihedral)/2,0,0]){
translate([0,magnetdepth-.2,thickness/2]){
rotate([90,0,0]){
linear_extrude(center=false, height=magnetdepth+0.2) {
circle(magnetdiam/2);
}}}
}}

}


difference(){
	mainbody();
		union(){
		chamfers();
		magnets();
	}
}



