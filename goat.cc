#include <iostream>

using namespace std;



int getMax(int* weights, int size, int cap) 
{
  int max=0, maxIdx=-1, i;
  bool swap = false;
    
  for( i=0; i<size; i++)
  {
    if (max<weights[i] && weights[i]<=cap)
    {
      max=weights[i];
      maxIdx=i;
      swap = true;
    }
  }
  if(max)
  {
    weights[maxIdx]=-1;
    return max;
  }
  return 0;
}

int getGoats(int* weights, int size)
{
  int cnt =0;
  for (int i=0; i<size; i++)
  {
    if (weights[i]>=0)
      cnt++;
  }
  return cnt;
}

void cpy(int* arr1, int* arr2, int size)
{
  for(int i=0; i<size; i++)
    arr2[i] = arr1[i];    
}

int getMiddle(int* arr, int size, int k)
{
  int middle =0; 
  for(int i=0; i<size; i++)
    middle+=arr[i];
  return middle/k;
}

int main()
{  
 
  int n=-1;
  int k=-1;
 
  cin >> n;
  if (n < 1 || n > 1000)
    return -1;
  
  cin >> k;
  if (k < 1 || k > 1000)
    return -2;
  
  int* startWeights = new int [n];
  int* weights = new int [n];
  for(int i=0; i<n; i++)
  {
      cin >> startWeights[i];
      if(startWeights[i]<1 || startWeights[i]>100000)
	return -3;
    
  }
   
   for(int cap=getMiddle(startWeights, n, k); ; cap++)
   {
     cpy(startWeights, weights, n);
      for(int i=1; i<=k; i++)
      {
	
	int max = getMax(weights, n, 100000);
	cap = cap > max? cap : max;
	int currCap = cap;
	
	while(max)
	{
	  currCap-=max;
	  max = getMax(weights, n, currCap); 

	}
	if(!getGoats(weights, n))
	  break;
      }
     
      if (!getGoats(weights, n))
      {
	cout <<cap << endl;
	break;
      }
      
   }

  
  return 0;
}

