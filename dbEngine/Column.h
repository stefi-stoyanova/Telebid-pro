#ifndef COLUMN_H
#define COLUMN_H

#include <iostream>
#include <string>
using namespace std;

const int INT_TYPE = 1;
const int STRING_TYPE = 2;
const int COLUMN_NAME_SIZE = 255;

class Column
{

public:
	int type;
	string name;
    bool hasIndex; 	

    Column(): name(""), type(-1), hasIndex(false) {};
	Column(string colName, int colType, bool index) : name(colName), type(colType), hasIndex(index) {}
};

#endif