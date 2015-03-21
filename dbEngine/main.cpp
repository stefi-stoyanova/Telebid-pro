#include <iostream>
#include "Table.h"
#include <string>
#include <vector>
#include <utility>
#include <stdlib.h>
#include <sstream>
#include <ctime>
#include "BinaryTree.h"
using namespace std;



int main()
{

	FILE* file = fopen("indexTest.dat", "r+");
	if(!file)
	{
		throw "File not open!";
	}


 	/*Node node;
 	node.data = 5;
 	node.adress = 50000;
 	node.exists = true;
 	node.write(file);
	
 	Node node1;
	node1.data = 1;
 	node1.adress = 1000;
 	node1.exists = true;
 	node1.write(file);*/
	
	/*node.read(file);
	node1.read(file);
	cout << node.exists << " " << node.data << " " << node.adress << endl;
	cout << node1.exists << " " << node1.data << " " << node1.adress << endl;*/

    BinaryTree b;


    b.addValue(5, 43);
    b.addValue(3, 43);
    b.addValue(-3, 43);
    b.print();

    b.write(file);

    return 0;
}