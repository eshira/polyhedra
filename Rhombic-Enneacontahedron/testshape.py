import math
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import numpy as np
import pyny3d.geoms as pyny

# There is a remaining degree of freedom in the truncation step
# this number must be greater than 2
# if it gets very large, it begins to resemble a rhombic triacontahedron
# To get evenly spaced truncation, set this to 3 (to divide the edge into equal portions)
ALONG_EDGE = 3

def icopoints(phi=(math.sqrt(5)-1)/2):
	#define the points for an icosahedron
	vertices = [[0,1,phi],[0,1,-phi],[0,-1,phi],[0,-1,-phi],[1,phi,0],[1,-phi,0],[-1,phi,0],[-1,-phi,0],[phi,0,1],[-phi,0,1],[phi,0,-1],[-phi,0,-1]]
	return vertices

def icofaces():
	#define the faces for an icosahedron according to the icopoints defined above
	return [[2, 9, 8],
		[5, 2, 8],
		[7, 9, 2],
		[0, 8, 9],
		[0, 4, 8],
		[4, 5, 8],
		[5, 3, 2],
		[3, 7, 2],
		[7, 6, 9],
		[6, 0, 9],
		[6, 1, 0],
		[1, 4, 0],
		[4, 10, 5],
		[10, 3, 5],
		[3, 11, 7],
		[11, 6, 7],
		[1, 10, 4],
		[10, 11, 3],
		[11, 1, 6],
		[1, 11, 10]
		]

def icoedges():
	#define the 30 edges based on the faces defined above
	faces = icofaces()
	edges = {}
	for i in range(len(faces)):
		edges[tuple(sorted([faces[i][0],faces[i][1]]))]= ''
		edges[tuple(sorted([faces[i][1],faces[i][2]]))]= ''
		edges[tuple(sorted([faces[i][2],faces[i][0]]))]= ''
	return edges

def truncate():
	#for now just does the truncated icosahedron
	#can be made into a general purpose function later
	#for every point, find which edges it belongs to
	#for each edge, create a new point,
	#that is moved 1/3 of the way inward on that edge

	points = icopoints()
	newpoints = []
	edges = icoedges().keys()

	for i in range(len(points)):
		matching_edges = [x for x in edges if i in x]
		for e in matching_edges:
			for p in e:
				if i==p:
					thispoint = np.array([points[p][0],points[p][1],points[p][2]])
				else:
					thatpoint = np.array([points[p][0],points[p][1],points[p][2]])
			newpoints.append(thispoint-(thispoint-thatpoint)/ALONG_EDGE)
	return newpoints

newpoints = truncate() # the points of tI, the truncated icosahedron
pentagons = []
toplot = []

#Create the five sided polygons
for i in np.arange(0,len(newpoints),5):
	pentagons.append(pyny.Polygon(np.array(newpoints[i:i+5])))
	#toplot.append(sum(np.array(newpoints[i:i+5]))/5)

#Create the six sided remaining polygons
#For every original face
#	For of its original vertices
#		For all the newly created vertices off that og vertex
#			Select only those coplanar with this original face
ogfaces = icofaces()
ogverts = icopoints()
newfaces = []
hexagons = []
arrows = []

for i,ogface in zip(range(len(ogfaces)),ogfaces): #for every one of the original faces
	plane = [np.array(ogverts[x]) for x in ogface[0:3]]
	coplanar = []
	for j,vert in zip(range(len(ogface)),ogface): # for every vertex in the original face
		candidates = newpoints[(vert*5):(vert*5)+5] # the corresponding newly spawned vertices
		for k,candidate in zip(range(len(candidates)),candidates): # for each of these, keep only those coplanar to this face
			new = np.array(candidate)
			if (np.dot((plane[1]-plane[0]),np.cross(a=(plane[2]-plane[0]),b=(new-plane[0]))) < 0.000000001 ):
				coplanar.append(vert*5+k)
	newfaces.append(coplanar)
#Make these newfaces into pyny.Polygons for later plotting
for i,face in zip(range(len(newfaces)),newfaces):
	hexagons.append(pyny.Polygon(np.array([newpoints[x] for x in face])))	

#find the edge between the two six sided faces
edge = [newpoints[newfaces[0][5]],newpoints[newfaces[0][1]]]
edgemidpt = sum(edge)/2
#arrows.append(np.concatenate([edge[0],edge[1]-edge[0]]))
#find the midpoint of one face
facepoint1 = sum([newpoints[x] for x in newfaces[0]])/6
#find the midpoint of another face, adjacent to the one before
facepoint2 = sum([newpoints[x] for x in newfaces[1]])/6
#find d, the distance between a face midpoint and a midpoint on one of its edges
d = np.linalg.norm(edgemidpt-facepoint1)
#find beta, the dihedral angle between six sided faces
vec_a = facepoint1-edgemidpt
vec_b = facepoint2-edgemidpt
beta = np.arccos(np.dot(vec_a,vec_b)/(np.linalg.norm(vec_a)*np.linalg.norm(vec_b)))
# compute h, the height 
h=d*np.tan((np.pi-beta)/2)

#Make a dictionary storing info on adjacency of faces
adjacenctfaces = {}
for i,face in zip(range(len(newfaces)),newfaces):
	adjacents = []
	for j,neighbor in zip(range(len(newfaces)),newfaces):
		if (face==neighbor):
			pass
		else:
			intersect = set(neighbor).intersection(set(face))
			if(len(intersect)!=0): #presumably always 2 if nonzero
				adjacents.append(neighbor)
	adjacenctfaces[tuple(face)]=adjacents

#Find the new broad rhombi (the ones in patterns of 3), are we drawing these 3 times? Maybe
newrhombi = []
raisedpoints = []
hextopoint = {} # a dictionary with hexagons as keys and raised 3-rhombi intersection points as values

for i,face in zip(range(len(newfaces)),newfaces):
	neighbors = adjacenctfaces[tuple(face)]
	#compute my new facepoint
	facepoint = sum([newpoints[x] for x in face])/6
	vec1 = [newpoints[x] for x in face[0:2]]
	vec1 = vec1[1]-vec1[0]
	vec2 = [newpoints[x] for x in face[1:3]]
	vec2 = vec2[1]-vec2[0]
	# face normal as cross of two noncolinear face vectors
	facenorm = np.cross(vec2,vec1)	
	#fix normals to point outward
	#by comparing the norm of the point plus, minus the facenorm
	if(np.linalg.norm(facepoint+facenorm) < np.linalg.norm(facepoint-facenorm)):
		facenorm = np.cross(vec1,vec2)
	# center point raised along facenorm by a set distance
	facenorm = facenorm/np.linalg.norm(facenorm)		
	#toplot.append(facepoint)
	#arrows.append(np.concatenate([facepoint,h*facenorm]))
	raisedpoints.append(facepoint+h*facenorm)
	hextopoint[tuple(face)]=i #store index of the point in the list raisedpoints
	for neighbor in neighbors:
		#compute their new facepoint
		neighborpoint = sum([newpoints[x] for x in neighbor])/6
		vec1 = [newpoints[x] for x in neighbor[0:2]]
		vec1 = vec1[1]-vec1[0]
		vec2 = [newpoints[x] for x in neighbor[1:3]]
		vec2 = vec2[1]-vec2[0]
		# face normal as cross of two noncolinear face vectors
		neighbornorm = np.cross(vec2,vec1)	
		#fix normals to point outward
		#by comparing the norm of the point plus, minus the facenorm
		if(np.linalg.norm(neighborpoint+neighbornorm) < np.linalg.norm(neighborpoint-neighbornorm)):
			neighbornorm = np.cross(vec1,vec2)
		# center point raised along facenorm by a set distance
		neighbornorm = neighbornorm/np.linalg.norm(neighbornorm)		
		#compute the intersection of the set of vertices
		sharededge = set(face).intersection(set(neighbor))
		#add the pyny polyhedron to the set
		p1 = newpoints[sharededge.pop()]
		p2 = newpoints[sharededge.pop()]
		new = pyny.Polygon(np.array([p1,facepoint+h*facenorm,p2,neighborpoint+h*neighbornorm]))
		newrhombi.append(new)

#find the edge of any pentagonal face
#toplot.append(newpoints[0])
#toplot.append(newpoints[1])
#find the face midpoint of a pentagon that shares that edge 
pentface = range(5)
facepoint1 = sum([newpoints[x] for x in pentface])/5
#toplot.append(facepoint1)
midedge = sum([newpoints[0],newpoints[1]])/2
#toplot.append(midedge)
d2 = np.linalg.norm(midedge-facepoint1)
#toplot.append(raisedpoints[3])
vec_a = facepoint1 - midedge
vec_b = raisedpoints[3] - midedge
alpha = np.arccos(np.dot(vec_a,vec_b)/(np.linalg.norm(vec_a)*np.linalg.norm(vec_b)))
h2 = d2*np.tan(np.pi-alpha)

newrhombi2=[]
raisedpoints2=[]
#Figure out which hexagons are next to which pentagons
for i in np.arange(0,len(newpoints),5): # for each pentagon
	thisface = [x for x in range(i,i+5,1)] # the pentagon list of verts
	#compute the face midpoint raised up the h2 along facenorm
	facepoint1 = sum([newpoints[x] for x in thisface])/5
	#draw an arrow from pentagonal midpoint, along facenorm, of magnitude h
	vec1 = newpoints[i]-newpoints[i+1]
	vec2 = newpoints[i]-newpoints[i+2]
	facenorm = np.cross(vec2,vec1)	
	#fix normals to point outward by comparing the norm of the point plus, minus the facenorm
	if(np.linalg.norm(facepoint1+facenorm) < np.linalg.norm(facepoint1-facenorm)):
		facenorm = np.cross(vec1,vec2)
	# center point raised along facenorm by a set distance
	facenorm = facenorm/np.linalg.norm(facenorm)
	#arrows.append(np.concatenate([facepoint1,h2*facenorm]))
	#toplot.append(facepoint1)
	neighbors = []
	for j in range(5): # for each vert
		adj = [x for x in hextopoint.keys() if thisface[j] in x] # find adjacent hexes
		if len(adj) != 0: # but don't double count
			for thing in adj:
				if (thing not in neighbors): neighbors.append(thing)
	for neighbor in neighbors: # for each neighboring hexagon
		# get the raised point we need for drawing
		p1 = raisedpoints[hextopoint[tuple(neighbor)]]
		edgepoints = set(neighbor).intersection(set(thisface))
		p2 = newpoints[edgepoints.pop()]
		p3 = newpoints[edgepoints.pop()]
		p4 = facepoint1+h2*facenorm
		raisedpoints2.append(p4)
		#Make the slim rhombi!!!!
		#print(p1,p2,p3,p4)
		newrhombi2.append(pyny.Polygon(np.array([p1,p2,p4,p3])))		
		#toplot.append(p1)

#find an adjacent broad and slim rhombus
red = [newpoints[4],raisedpoints[11],newpoints[6],raisedpoints[10]]
blue = [newpoints[6],raisedpoints2[6],newpoints[5],raisedpoints[10]]
#for pt in red+blue:
#	toplot.append(pt)
fnorm = []
#compute red's face normal
for rhombus in [red,blue]:
	facepoint1 = sum(rhombus)/4
	toplot.append(facepoint1)
	vec1 = rhombus[0]-rhombus[1]
	vec2 = rhombus[0]-rhombus[2]
	# face normal as cross of two noncolinear face vectors
	facenorm = np.cross(vec2,vec1)	
	if(np.linalg.norm(facepoint1+facenorm) < np.linalg.norm(facepoint1-facenorm)):
		facenorm = np.cross(vec1,vec2)
	arrows.append(np.concatenate([facepoint1,5*facenorm]))
	fnorm.append(facenorm)
	arrows.append(np.concatenate([sum(red)/4,5*facenorm]))	
rednorm,bluenorm = fnorm
dihedral2 = np.arccos((np.dot(rednorm,bluenorm))/(np.dot(np.linalg.norm(rednorm),np.linalg.norm(bluenorm))))

#find two adjacent blue rhombi
blue1 = [raisedpoints[18],newpoints[9],newpoints[5],raisedpoints2[6]]
blue2 = [newpoints[6],raisedpoints2[6],newpoints[5],raisedpoints[10]]
#for pt in blue1+blue2:
#	toplot.append(pt)

fnorm = []
#compute face normal
for rhombus in [blue1,blue2]:
	facepoint1 = sum(rhombus)/4
	#toplot.append(facepoint1)
	vec1 = rhombus[0]-rhombus[1]
	vec2 = rhombus[0]-rhombus[2]
	# face normal as cross of two noncolinear face vectors
	facenorm = np.cross(vec2,vec1)	
	if(np.linalg.norm(facepoint1+facenorm) < np.linalg.norm(facepoint1-facenorm)):
		facenorm = np.cross(vec1,vec2)
	#arrows.append(np.concatenate([facepoint1,5*facenorm]))
	fnorm.append(facenorm)
	#arrows.append(np.concatenate([sum(blue1)/4,5*facenorm]))	
blue1norm,blue2norm = fnorm
dihedral = np.arccos((np.dot(blue1norm,blue2norm))/(np.dot(np.linalg.norm(blue1norm),np.linalg.norm(blue2norm))))

#find a red rhombus
red = [newpoints[4],raisedpoints[11],newpoints[6],raisedpoints[10]]
vec1 = red[1]-red[2]
vec2 = red[3]-red[2]
angle = np.arccos((np.dot(vec1,vec2))/(np.dot(np.linalg.norm(vec1),np.linalg.norm(vec2))))
red_interior1 = 180-np.rad2deg(angle)
#red_interior2 = np.rad2deg(angle)

#find a blue rhombus
blue = [newpoints[6],raisedpoints2[6],newpoints[5],raisedpoints[10]]

vec1 = blue[3]-blue[2]
vec2 = blue[1]-blue[2]
angle = np.arccos((np.dot(vec1,vec2))/(np.dot(np.linalg.norm(vec1),np.linalg.norm(vec2))))
obtuse = np.rad2deg(angle)

#arrows.append(np.concatenate([blue[3],blue[2]-blue[3]]))
#arrows.append(np.concatenate([blue[1],blue[2]-blue[1]]))

vec3 = blue[0]-blue[1]
vec4 = blue[2]-blue[1]
angle = np.arccos((np.dot(vec3,vec4))/(np.dot(np.linalg.norm(vec3),np.linalg.norm(vec4))))
blue_interior1a = np.rad2deg(angle);

vec5 = blue[0]-blue[3]
vec6 = blue[2]-blue[3]
angle = np.arccos((np.dot(vec5,vec6))/(np.dot(np.linalg.norm(vec5),np.linalg.norm(vec6))))
blue_interior1b = np.rad2deg(angle)

vecS = blue[1]-blue[0]
vecL = blue[3]-blue[0]
sidefactor = np.linalg.norm(vecS)/np.linalg.norm(vecL);

#polyhedron = pyny.Polyhedron(pentagons+hexagons+newrhombi)
polyhedron = pyny.Polyhedron(newrhombi2)
rhombi3s = pyny.Polyhedron(newrhombi)

ax = polyhedron.plot('b',ret=True)
rhombi3s.plot('r',ax=ax)


try:
	xs, ys, zs = tuple(zip(*toplot))
	xs = list(xs)
	ys = list(ys)
	zs = list(zs)
	ax.scatter(xs, ys, zs, c='cyan', marker='o',s=100)
except Exception as e:
	print(e)

try:
	X, Y, Z, U, V, W = zip(*arrows)
	ax.quiver(X, Y, Z, U, V, W,color='cyan')
except Exception as e:
	print(e)

print("Put into OpenSCAD")
print("dihedral2=",180-np.rad2deg(dihedral2),";")
print("dihedral=",180-np.rad2deg(dihedral),";")
print("alpha=",red_interior1,";")
print("beta=",blue_interior1a,";")
print("blue1b=",blue_interior1b,";")
print("obtuse=",obtuse,";")
print("sidefactor=",sidefactor,";")

plt.show()
