#include <iostream>
#include <string.h>
#include <stdio.h>

using namespace std;


void lToA(long long n, char* buffer)
{
  char* tmp = new char [strlen(buffer)+1];
  int i=0;
  while (n)
  {
    tmp[i] = (n%10) + '0';
    n/=10;
    i++;
  }
  tmp[i]=0;

  for(int k=strlen(tmp)-1, i=0; k>=0; k--, i++)
    buffer[i]=tmp[k];
  buffer[strlen(tmp)]=0;

  delete []tmp;
}
int main() {

  int n=-1;
  cin >> n;
  
  char* buffer = new char[n+32];
  char* tmp = new char[32];
  buffer[0] = '1';
  buffer[1] = 0;
  
  for(long long i=2; ; i++)
  {
      lToA(i*i, tmp);
      strcat(buffer, tmp);
    if(buffer[n-1])
    {
      cout << buffer[n-1] << endl;
      break;
    }
  }
  delete []buffer;
  delete []tmp;

  return 0;
}
