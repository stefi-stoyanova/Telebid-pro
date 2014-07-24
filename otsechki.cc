#include <iostream>
#include <fstream>

using namespace std;



int main() 
{
	
	int n,a,b,c;
	
	do
	{
		cin >> n >> a >> b >>c;
	} 
	while (!(n>0 && a>0 && b>0 && c>0 && n <100000&& a<100000 && b<100000 && c<100000));
	
	int metri=n;
	
	int* georgi =  new int[n/a];
	int * geri = new int [n/b];
	
	for(int i=0; a*i<=n; i++)
		georgi[i]=a*i;

	for(int i=0; b*i<=n; i++ )
	{
		geri[i]=n - b*i;
		for (int k=0; k<=n/a; k++)
		{
			if (geri[i]-georgi[k]==c || geri[i]-georgi[k]==-c)
				metri -=c;
		}
	}
	cout << metri << endl;
	
	delete []georgi;
	delete []geri;
	
	return 0;
	
}