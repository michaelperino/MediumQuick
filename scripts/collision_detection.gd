extends Node

# This script was from Geeks for Geeks, but the original webpage seems lost to time
# This is extremely similar https://www.geeksforgeeks.org/how-to-check-if-a-given-point-lies-inside-a-polygon/
var INT_MAX = 100000

func onSegment(p, q, r):
	 
	if ((q[0] <= max(p[0], r[0])) &&
		(q[0] >= min(p[0], r[0])) &&
		(q[1] <= max(p[1], r[1])) &&
		(q[1] >= min(p[1], r[1]))):
		return true
		 
	return false

func orientation(p, q, r):
	 
	var val = (((q[1] - p[1]) *
			(r[0] - q[0])) -
		   ((q[0] - p[0]) *
			(r[1] - q[1])))
			
	if val == 0:
		return 0
	if val > 0:
		return 1 # Collinear
	else:
		return 2 # Clock or counterclock
		
func doIntersect(p1, q1, p2, q2):
	# Find the four orientations needed for 
	# general and special cases
	var o1 = orientation(p1, q1, p2)
	var o2 = orientation(p1, q1, q2)
	var o3 = orientation(p2, q2, p1)
	var o4 = orientation(p2, q2, q1)
 
	# General case
	if (o1 != o2) and (o3 != o4):
		return true
	 
	# Special Cases
	# p1, q1 and p2 are colinear and
	# p2 lies on segment p1q1
	if (o1 == 0) and (onSegment(p1, p2, q1)):
		return true
 
	# p1, q1 and p2 are colinear and
	# q2 lies on segment p1q1
	if (o2 == 0) and (onSegment(p1, q2, q1)):
		return true
 
	# p2, q2 and p1 are colinear and
	# p1 lies on segment p2q2
	if (o3 == 0) and (onSegment(p2, p1, q2)):
		return true
 
	# p2, q2 and q1 are colinear and
	# q1 lies on segment p2q2
	if (o4 == 0) and (onSegment(p2, q1, q2)):
		return true
 
	return false
	
func is_inside_polygon(points, p):
	 
	var n = len(points)
	 
	# There must be at least 3 vertices
	# in polygon
	if n < 3:
		return false
		 
	# Create a point for line segment
	# from p to infinite
	var extreme = Vector2(INT_MAX, p[1])
	var count = 0
	var i = 0
	 
	while true:
		var next = (i + 1) % n
		 
		# Check if the line segment from 'p' to 
		# 'extreme' intersects with the line 
		# segment from 'polygon[i]' to 'polygon[next]'
		if (doIntersect(points[i],
						points[next],
						p, extreme)):
							 
			# If the point 'p' is colinear with line 
			# segment 'i-next', then check if it lies 
			# on segment. If it lies, return true, otherwise false
			if orientation(points[i], p,
						   points[next]) == 0:
				return onSegment(points[i], p,
								 points[next])
								  
			count += 1
			 
		i = next
		 
		if (i == 0):
			break
		 
	# Return true if count is odd, false otherwise
	return (count % 2 == 1)
	
func is_inside_circle(center, radius, p):
	if (pow((p[0]-center[0]),2) + pow(p[1]-center[1],2) < pow(radius,2)):
		return true
	else:
		return false
