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

    try
    {

    	

        Table table("table.dat");
        //table.readColumnsInFile();
        
        //string id = "id";
        //string int1 = "int";
       /* table.addColumn(id, 1, true);
        table.addColumn(int1, 1, false);
        table.writeColumnsInFile();*/

       /* vector<pair<string, string> > values;
        pair<string, string> p1(id, string("10"));
        pair<string, string> p2(int1, string("20"));

        values.push_back(p1);
        values.push_back(p2);
        table.insertLine(values);*/


        //table.readAllLines();




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


        FILE* file = fopen("id.dat", "r+");
        if(!file)
        {
            throw "File not open!";
        }

        BinaryTree b;
        b.search(file, 10);


        /*b.addValue(5, 43);
        b.addValue(3, 43);
        b.addValue(7, 43);
        b.addValue(12, 43);
        b.addValue(6, 43);
        b.addValue(-3, 43);
        b.print();
        b.write(file);*/
        /*b.addNode(file, 6, 138);
        b.addNode(file, 1, 1);
        b.addNode(file, 2, 2);
        b.addNode(file, 10, 10);*/
        
        //b.search(file, 10);
        //b.readAll(file);
        //b.deleteNode(file, 6, 43);
        //b.updateNode(file, 7, 43, 44);
    }   
    catch (const char* ex)
    {
        cerr << ex << endl;
    }
    return 0;
}