package core;

import nme.geom.Point;

class PointMath 
{
	public static inline function normalisedDifferenceVector(point1:Point, point2:Point)
	{
		var difference = differenceVector(point1, point2);
		var distance = distanceBetweenPoints(point1, point2);
		return normaliseVector(difference, distance);
	}
	
	public static inline function normaliseVector(vector:Point, distance:Float):Point
	{
		vector.x = vector.x / distance;
		vector.y = vector.y / distance;
		return vector;
	}	
	
	public static inline function differenceVector(point1:Point, point2:Point) {
		return new Point(point2.x - point1.x, point2.y - point1.y);
	}	
	
	public static inline function distanceBetweenPoints(point1:Point, point2:Point):Float {
		return Math.sqrt(((point2.x - point1.x) * (point2.x - point1.x)) + ((point2.y - point1.y) * (point2.y - point1.y)));
	}
}