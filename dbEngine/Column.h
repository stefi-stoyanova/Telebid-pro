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

    Column(): name(""), type(-1){};
	Column(string colName, int colType) : name(colName), type(colType) {}
};

#endif