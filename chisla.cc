#include <iostream>
#include <math.h>
#include <time.h>
using namespace std;

int cntSymbols(long long n)
{
    int i=0;
    while (n)
    {
        n/=10;
        i++;
    }
    return i;
}

int getAtPos(long long n, int pos)
{
    return (n/ (int)pow(10, cntSymbols(n)-pos))%10;
}


int main()
{
    int n=-1;
    do
        cin >> n;
    while(n<=0 || n>=3200000);

    int cnt=0;

    for (long long i=1; ;i++)
    {
        cnt+=cntSymbols(i*i);
        if (cnt==n)
        {
           cout << (i*i)%10 << endl;
           break;
        }
        else if(cnt>n)
        {
            cout << getAtPos(i*i, cnt-n) << endl;
            break;
        }
    }

    return 0;
}
