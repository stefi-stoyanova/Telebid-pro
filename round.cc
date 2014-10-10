#include <iostream>
#include <cmath>
#include <fstream>
#include <vector>

using namespace std;



double getLength(int x1, int y1, int x2, int y2)
{

	int a = abs(x1-x2);
	int b = abs(y1-y2);
	return sqrt(a*a+b*b);
}


int main() {

	int n=-1;
	do
	{
		cout << "Vuvedi n: " << endl;
		cin >> n;
	}
	while (n<2 || n>1000);
	
	
	
	ofstream out("round.html");
	out << "<!DOCTYPE html>\n<html>\n<body>\n<canvas id='myCanvas' width='1024' height='1000'> </canvas>\n<script>\n";
	out << "var c=document.getElementById('myCanvas');\n var ctx=c.getContext('2d');";

	
	
	int **circle = new int* [n]; 

	
	for(int i=0; i<n; i++)
	{
		circle[i]= new int [3];
		
		do
		{
			cout << "Vuvedi x y r: " << endl;
			for (int k=0; k<3; k++)
				cin >> circle[i][k];
		}
		while (circle[i][0]<=-10000 || circle[i][0]>=10000 || circle[i][1]<=-10000 || circle[i][1]>=10000 || circle[i][2]<= 0 || circle[i][2]>=10000);
		
		out << "ctx.beginPath();\n ctx.arc(" << circle[i][0] << "," << circle[i][1] << "," << circle[i][2] << ",0,2*Math.PI);\n ctx.stroke();\n ctx.closePath();\n";
				
		for (int k = 0; k<i; k++)
		{
			double length = getLength(circle[i][0],circle[i][1], circle[k][0], circle[k][1]) ;
			if (length< (circle[i][2]+circle[k][2]) && length > min(circle[i][2], circle[k][2]))
				cout << i << " i " << k << " se presichat!" << endl;

		}
	}
	

	out << "</script>\n</body>\n</html>\n";
	return 0;
}