 
#include <iostream>
#include <iomanip> 

using namespace std;


void gnili(int** arr, int K, int L, int k1, int k2, int day)
{
  if(k1-1>=0 && arr[k1-1][k2]==0)
    arr[k1-1][k2] = day;
  if(k1+1<K && arr[k1+1][k2]==0)
    arr[k1+1][k2] = day;
  if(k2-1>=0 && arr[k1][k2-1]==0)
    arr[k1][k2-1] = day;
  if(k2+1<L && arr[k1][k2+1]==0)
    arr[k1][k2+1] = day; 
}

void print(int** arr, int K, int L)
{
  for(int i=0; i< K; i++)
  {
    for(int k=0; k<L; k++)
      cout << setw(4) << arr[i][k];
    cout << endl;
  }
  cout << endl;
}

int main() {
  
  
  int K=-1, L=-1, R=-1;
  
  cin >> K >> L >> R;
  
  if(K<=0 || K>L || L>1000 || R<=0 || R>100)
    return -1;
  
  int** arr = new int* [K];
  for(int i=0; i<K; i++)
  {
    arr[i] = new int [L];
    for(int k=0; k<L; k++)
      arr[i][k]=0;
  }
  
  int k1=-1, k2=-1;
  for(int i=0; i<2; i++)
  {
    cin >> k1 >> k2;
    k1= K-k1;
    k2--;
    if (k1>=0 && k1<K && k2>=0 && k2<L)
      arr[k1][k2]=1;
  }
  print(arr,K,L);
  
  for (int r=1; r<=R; r++)
  {
    for(int i=0; i<K; i++)
    {
      for(int k=0; k<L; k++)
      {
	if(arr[i][k]==r)
	  gnili(arr, K, L, i, k, r+1);
      }
    }
  }
  
  int cnt=0;
  for(int i=0; i<K; i++)
    for(int k=0; k<L; k++)
      if (!arr[i][k])
	cnt++;
      
  cout << cnt << endl;
  print(arr, K, L);
  return 0;
}
