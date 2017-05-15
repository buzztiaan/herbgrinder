
//https://www.thingiverse.com/thing:1654620

use <BezierScad.scad>;

//***** ************   *****
$fn=64;

//translate([50,0,0]) base();
//rotate([180,0,0]) translate([100,0,-18]) top();
rotate([180,0,0]) translate([0,0,-16]) sieve();


module screw (Sta,End,Pas,Ray){ // filet - thread
Ste=5;//pas angulaire
//Pas mm/360°
//Ray rayon centre du motif
//Sta angle de départ
//End angle de fin   
for (Rz = [Sta:Ste:End]) {//Rz rotation Z
    a= Rz>Sta ? 1: 0;
    b= Rz<End ? 1: 0;
Ap=Pas*(Rz-Sta)/360;//Ap avancement du pas en Z
Ap1=Ap+Pas*Ste/360;//Ap1 avancement du pas en Z+1
hull (){
rotate ([0,0,Rz])translate([Ray,0,Ap])motif (a);
rotate ([0,0,Rz+Ste]) translate([Ray,0,Ap1])motif (b);
}
}
}
  

module motif (a){//trapeze - threadform
//$Z1 largeur base
//$Z2 largeur sommet
//$X1 distance base sommet  
// dans le plan x-z
cube([0.1,0.1,$Z1],true);
translate([-a*$X1,0,0])cube([0.1,0.1,$Z2],true);
} 


module bouchon (Rb,Hb,Ep,Nc){//cap
//Rb ray bouchon interieur
//Hb haut bouchon interieur
//Eb epais bouchon
//Nc nb crans

difference(){
   
translate ([0,0,(Hb+Ep)/2])cylinder(Hb+Ep, r=Rb+Ep, center=true);
        translate ([0,0,(Ep)/2])
        
translate ([0,0,Hb/2+Ep])cylinder(Hb, r=Rb, center=true);  
   
    }
    // crans
for (Rz = [0:360/Nc:360]) {
rotate ([0,0,Rz])translate ([Rb+Ep,0,Hb/2+Ep])cube([Ep/2,Ep,Hb],true);
}
    }
 
 module goulot (Rb,Hb,Ep){//neck
//Rb ray goulot exterieur
//Hb haut goulot 
//Eb epais goulot

difference(){
 union(){  
hull(){//exterieur
    translate ([0,0,Hb/2])cylinder(Hb, r=Rb-Ep/3, center=true);translate ([0,0,(Hb-Ep/3)/2])cylinder(Hb-Ep/3, r=Rb, center=true);
} 
     hull(){//base
    translate ([0,0,Ep/4])cylinder(Ep/2, r=Rb+Ep, center=true);
    translate ([0,0,Ep/2])cylinder(Ep, r=Rb, center=true); 
       }  
}     
translate ([0,0,Hb/2])cylinder(Hb, r=Rb-Ep, center=true); //interieur 
   
    }
    }    


module base () {
jeu=0.5;//jeu
Ray=44/2+jeu;//rayon centre du motif
Pas=9;//pas de vis
Ep=1.5;//épaisseur bouchon
Ej=0;//épaisseur joint gasket
Dd=15.5+Ej+(Pas/3)/2;//distance demarrage depuis la base
Df=2;//distance fin
    
$Z1=2;//largeur base
$Z2=1;//largeur sommet
$X1=1;//distance base sommet (std 1.0)

translate([0,0,Ep+Dd]){
screw (0,180,Pas,Ray);
screw (120,300,Pas,Ray);
screw (240,420,Pas,Ray);
}
union(){
    bouchon (Ray,Dd+Pas/2+Df,Ep,32);
    difference () {
        cylinder (r=Ray,h=Dd-0.5, fn=200);
        translate([0,0,-0.05]) cylinder (r=Ray-1.5,h=Dd-0.5+0.1, fn=200);
    }
}
}

module top() {
    
    jeu=-3.4;
Ray=42/2+jeu;//rayon centre du motif
Pas=9;//pas de vis
Ep=1.5;//épaisseur bouchon
Ej=0;//épaisseur joint gasket
Dd=15.5+Ej+(Pas/3)/2;//distance demarrage depuis la base
Df=2;//distance fin
    
    cylinder(r=(42/2)-1.8,h=23);
    
    translate([0,0,4]) 
    difference () {
        top_cutpattern();
        translate([0,0,-9]) 
        difference() {
            cylinder(r=42,h=10);
            cylinder(r=(42/2)-1.8,h=10);
            
        } }
    
     sphere(r=3.5);   
        
        
        
        //bouchon (Ray,Dd+Pas/2+Df,Ep,32);
//module bouchon (Rb,Hb,Ep,Nc){//cap

        
    // crans
for (Rz = [0:360/32:360]) {
rotate ([0,0,Rz])translate ([Ray+Ep,0,(Dd+Pas/2+Df)/2+Ep+4.9])cube([Ep/2,Ep,8],true);
}
}


module top_cutpattern () {
    
    
    rotate([0,180,0])
    for(i = [1 : 5]) {
        rotate([0,0,i*(360/5)])
        translate([6,-11,-.2])
        rotate([-6,-5,-170])        
        one_leaf_inv(10,30);
    }
    
}

module sieve  () {
Ray=42/2;//rayon externe
Pas=9;//pas de vis
Ep=1.4;//épaisseur bouchon
Dd=15.2;//hauteur depuis l'épaulement
Df=1.5;//distance fin
    
$Z1=2;//largeur base
$Z2=1;//largeur sommet
$X1=-1;//distance base sommet (std 1.165)

translate([0,0,Dd+Ep-Df-Pas/2-$Z1/2]){
screw (0,180,Pas,Ray);
screw (120,300,Pas,Ray);
screw (240,420,Pas,Ray);
}

union() {

difference(){
    goulot (Ray,Dd+Ep,Ep);
    //biseautage
translate ([0,0,Dd-0.1])cylinder(h=(2*Ep), r1=Ray-Ep, r2=Ray-Ep/1.5, center=true);
}
    translate([0,0,Dd-1.1]) 
    difference() {
        cylinder(r=Ray-Ep+0.5,h=2.5);
        sieve_pattern();
    }
}
}

module sieve_pattern () {
    difference() {
        for(i = [1 : 6]) {
            rotate([0,0,i*60])
            translate([2,-7,-.2]) one_leaf(2.8,4.5);
        
            rotate([0,0,i*60])
            translate([10,9,-.2]) cylinder(r=2.25,h=5,$fn=6);
        }
        translate ([0,0,-5]) 
        difference() {
            cylinder(r=42/2,h=10);
            cylinder(r=33/2,h=12);
        }
        
    }
}

module one_leaf (s1,s2) {
      
    linear_extrude(height = 4) 
    BezLine([
        [2,10], [4, 20], [0,25]
    ], width = [s1, s2], resolution = 3, centered = true, showCtls = false);
}

module one_leaf_inv (s1,s2) {
      
    linear_extrude(height = 4) 
    BezLine([
        [2,0], [-6, -20], [0,-35]
    ], width = [s1, s2], resolution = 4, centered = true, showCtls = false);
}


