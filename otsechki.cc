#include <iostream>
#include <fstream>

using namespace std;



int main() 
{
	
	int n,a,b,c;
	
	do
	{
		cout << "Enter 4 numbers: \n";
		cin >> n >> a >> b >>c;
		if(!cin) 
		{
			cout << "Wrong input!\n";
			return -1;
		} 
	
	}
	while (!(n>0 && a>0 && b>0 && c>0 && n <100000&& a<100000 && b<100000 && c<100000));
	
	
	ofstream out("otsechki.html");
	out << "<html>\n<body>\n <table  width= \"80%\" borger=\"10\"><tr>";
	
	int metri=n;
	
	int* arr =  new int[n+1];
	for(int i=0; i<n+1; i++)
		arr[i]=0;
	
	for(int i=0; a*i<=n; i++)
		arr[a*i]=1;

	for(int i=0; b*i<=n; i++ )
	{
		if(arr[b*i]==1)
			arr[b*i]=3;
		else
			arr[b*i]=2;		
	}
	
	for(int i=0; i+c<n+1; i++)
	{
		if(arr[i] && arr[i+c] && (arr[i]!=arr[i+c] || arr[i]==3) )
		{
			metri-=c;
			out << "<td bgcolor = \"#FF0000\">\n";
		}
		else 
		{
			out << "<td bgcolor=\"#0000FF\"></td>\n";
		}
	}
	
	cout << metri << endl;
	out << "</tr></table></body>\n</html>";
	out.close();
	delete []arr;
		
	return 0;
	
}