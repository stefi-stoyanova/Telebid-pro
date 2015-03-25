#ifndef TABLE_H
#define TABLE_H

#include <vector>
#include <string>
#include <cstdio>
#include <utility>
#include <cstdlib>
#include <cstring>

#include "Column.h"
#include "BinaryTree.h"

using namespace std;

class Table
{
	FILE* file;
	vector<Column*> columns;
	int lines;

public:
	Table(const char* fileName);
	~Table();

	void createTable(string tableName); 

	void writeColumnsInFile();
	void readColumnsInFile();

	void addColumn(string& name, int type, bool hasIndex = false);
	void insertLine(vector<pair<string,string> >& values);
	void updateLine(vector<pair<string,string> >& values, const char* name, const char* value);

	int getLinesStartPosition();
	void readAllLines();
	void readLines(const char* name, const char* val); 


	int deleteLine(const char* name, const char* value);

private:
	void skipColumn(int);

};


Table::Table(const char* fileName)
{
	lines = 0;
	file = fopen(fileName, "r+");
	if(!file)
	{
		file = fopen(fileName, "w");
		fclose(file);
	}
	
	file = fopen(fileName, "r+");
	if(!file)
	{
		throw "File not open!";
	}
}



void Table::addColumn(string& name, int type, bool hasIndex)
{
	if(hasIndex)
	{
		FILE* indexFile = fopen((name + ".dat").c_str(), "w");
		fclose(indexFile);
	}
	columns.push_back(new Column(name, type, hasIndex));
}


void Table::writeColumnsInFile()
{
	int columnsCount = columns.size();

	fseek(file, 0, SEEK_SET);
	fwrite(&columnsCount, sizeof(columnsCount), 1, file);
	
	for(int i = 0; i < columnsCount; i++)
	{
		
		fwrite(&columns[i]->type, sizeof(columns[i]->type), 1, file);
		int nameLength = columns[i]->name.length();
		
		fwrite(&nameLength, sizeof(nameLength), 1, file);
		
		fwrite(columns[i]->name.c_str(), sizeof(char), COLUMN_NAME_SIZE, file);
	}
	fwrite(&lines, sizeof(lines), 1, file);
}

void Table::readColumnsInFile()
{
	int columnsCount = 0;
	
	fseek(file, 0, SEEK_SET);
	fread(&columnsCount, sizeof(int), 1, file);
	//cout << "COLUMNS: " << columnsCount << endl;
	/*return;*/
	int nameLength = 0;

	for(int i = 0; i < columnsCount; i++)
	{
		Column* c = new Column();
		fread(&c->type, sizeof(c->type), 1, file);
		
		fread(&nameLength, sizeof(nameLength),1, file);
		char* buffer  =  new char[nameLength];
		
		fread(buffer, 1, nameLength,  file);

		c->name = string(buffer);
		FILE* indexFile = fopen((c->name + ".dat").c_str(), "r");
		if(indexFile)
		{
			c->hasIndex = true;
			cout << "hasIndex TRUE: " << c->hasIndex << endl;
		}
		//cout << nameLength << endl;
		//cout << c->name << endl;
		columns.push_back(c);
		fseek(file, COLUMN_NAME_SIZE - nameLength, SEEK_CUR);
		delete []buffer;
		//delete c;
	}
	fread(&lines, sizeof(lines), 1, file);
}

Table::~Table()
{
	int linesPosition = sizeof(int) + (columns.size() * (sizeof(int) + sizeof(int) + COLUMN_NAME_SIZE));
	fseek(file, linesPosition, SEEK_SET);
	fwrite(&lines, sizeof(lines), 1, file);
	int size = columns.size();

	for (int i = 0; i < size; ++i)
	{
		delete columns[i];
	}

	fclose(file);
}

void Table::insertLine(vector<pair<string,string> >& values)
{
	if(values.size() != values.size())
		throw "Invalid parameters 1!";

	fseek(file, 0, SEEK_END);
	fwrite("1", 1, 1, file);
	long linePosition = ftell(file);
	for(int i = 0; i < columns.size(); i++)
	{
		int k = 0;
		bool found = false;
		for(; k < values.size(); k++)
		{
			if(columns[i]->name == values[k].first)
			{
				found = true;
				break;
			}
		}
		if(!found)
			throw "Invalid parameters!";

		if(columns[i]->type == INT_TYPE)
		{
			int value = atoi(values[k].second.c_str());
			fwrite(&value, sizeof(value), 1, file);

			cout << "INDEX insert: " << columns[i]->hasIndex << endl;
			if(columns[i]->hasIndex)
			{
				cout << "COLUMN " << columns[i]->name << " has index" << endl;
				FILE* fileIndex = fopen((columns[i]->name + ".dat").c_str(), "r+");
		    	if(!fileIndex)
		    	{
		    		throw "File not open!";
		    	}
		    	BinaryTree b; 
		    	b.addNode(fileIndex, value, linePosition);
		    	fclose(fileIndex);
			}
		} 
		else if( columns[i]->type == STRING_TYPE)
		{
			int valueLength = values[k].second.length();
			fwrite(& valueLength, sizeof(valueLength), 1, file);
			const char* buff = values[k].second.c_str();
			fwrite(buff, sizeof(char), valueLength, file);
		}
	}
	lines++;
}

int Table::getLinesStartPosition()
{
	int columnsCount = columns.size();
	return 2 * sizeof(int) + (columnsCount * (sizeof(int) + sizeof(int) + COLUMN_NAME_SIZE));
}
void Table::readAllLines() 
{
	fseek(file, getLinesStartPosition(), SEEK_SET);

	for(int i = 0; i < lines; i++)
	{
		int isLine = fgetc(file);
		for(int k = 0; k < columns.size(); k++)
		{
			if(isLine == '1')
			{
				if(columns[k]->type == INT_TYPE)
				{
					int value = -1;
					fread(& value, sizeof(value), 1, file);
					cout << columns[k]->name << ": " << value << endl;
				} 
				else if(columns[k]->type == STRING_TYPE)
				{
					int length = -1;
					fread(& length, sizeof(length),1, file);
					char* buffer = new char[length];
					fread(buffer, sizeof(char), length, file);
					cout << columns[k]->name << ": " ;
					for(int i = 0; i < length; i++)
					{
						cout << buffer[i];
					}
					cout << endl;
					delete[] buffer;
				}
			}
			else
			{
				skipColumn(columns[k]->type);
			}
		}
	}
}


void Table::readLines(const char* name, const char* val) 
{
	fseek(file, getLinesStartPosition(), SEEK_SET);

	int columnSize = columns.size();

	int searched = 0;
	for (; searched < columnSize; ++searched)
	{
		if(!strcmp(columns[searched]->name.c_str(), name))
			break;
	}

	int searchedValue;
	if(columns[searched]->type == INT_TYPE)
		searchedValue = atoi(val);

	bool found = false;
	int ifc =0, elsec = 0;
	for(int i = 0; i < lines; i++)
	{
		int pos = ftell(file);
		int isLine  = fgetc(file);
		if(found)
		{
			found = false;
			fgetc(file);
			for (int k = 0; k < columnSize; ++k)
			{
				if(columns[k]->type == INT_TYPE)
				{
					int value = -1;
					fread(& value, sizeof(value), 1, file);
					//cout << columns[k]->name << ": " << value << endl;
				} 
			}
		
			continue;
		}
		if(isLine == '1')
		{
			for(int k = 0; k < columnSize; k++)
			{

				if(k == searched || true)
				{
					++ifc;
					if(columns[k]->type == INT_TYPE)
					{
						int value = -1;
						fread(& value, sizeof(value), 1, file);
						if(value == searchedValue)
						{
							//cout << "FOUND" << endl;
							--i;
							found = true;
							//fseek(file, pos, SEEK_SET);
							//cout << "pos: " << pos << " curpos: " << ftell(file) << endl;
							fseek(file, pos - 1 - ftell(file), SEEK_CUR); 
							break;
						}
						//cout << columns[k]->name << ": " << value << endl;
					} 
					else if(columns[k]->type == STRING_TYPE)
					{
						int length = -1;
						fread(& length, sizeof(length), 1, file);
						char* buffer = new char[length];
						fread(buffer, sizeof(char), length, file);
						//cout << columns[k]->name << ": " ;
						//for(int i = 0; i < length; i++)
						//{
						//	cout << buffer[i];
						//}
						//cout << endl;
						delete[] buffer;
					}
				}
				else
				{
					++elsec;
					skipColumn(columns[k]->type);
				}
			}
		}
		else
		{
			for(int k = 0; k < columnSize; k++)
				skipColumn(columns[k]->type);
		}
	}
	//cout << "IF: " << ifc << " ELSE: " << elsec << endl;
}

void Table::updateLine(vector<pair<string,string> >& values, const char* name, const char* value)
{
	int deletedLines = deleteLine(name, value);

	cout << values[0].second << endl << endl;
	for(int i = 0; i < deletedLines; i++)
	{
		insertLine(values);
	}
}



int Table::deleteLine(const char* name, const char* value)
{
	int deletedLines = 0;

	fseek(file, getLinesStartPosition(), SEEK_SET);
	
	for(int i = 0; i < lines; i++)
	{	
		int linePos = ftell(file);
		int isLine  = fgetc(file);
		if(isLine == '1')
		{	
			for(int k = 0; k < columns.size(); ++k)
			{
				if(!strcmp(columns[k]->name.c_str(), name))
				{
					if(columns[k]->type == INT_TYPE)
					{
						if(columns[i]->hasIndex)
						{
							cout << "COLUMN " << columns[i]->name << " has index" << endl;
							FILE* fileIndex = fopen((columns[i]->name + ".dat").c_str(), "r+");
					    	if(!fileIndex)
					    	{
					    		throw "File not open!";
					    	}
					    	BinaryTree b; 
					    	b.deleteNode(fileIndex, value, linePos);
					    	fclose(fileIndex);
						}

						int val = -1;
						fread(& val, sizeof(val), 1, file);
						if(val == atoi(value))
						{
							fseek(file, linePos, SEEK_SET);
							fwrite("0", 1, 1, file);
							fseek(file, -1, SEEK_CUR);
							i--;
							++deletedLines;
							break; 
							
						}
					}
					else if(columns[k]->type == STRING_TYPE)
					{
						int length = -1;
						fread(& length, sizeof(length), 1, file);
						char* buff = new char[length];
						fread(&buff, sizeof(char), length, file);
						if(!strcmp(buff, value))
						{
							fseek(file, linePos, SEEK_SET);
							fwrite("0", 1, 1, file);
							fseek(file, -1, SEEK_CUR);
							i--;
							delete []buff;
							++deletedLines;
							break; 
						}
						delete []buff;

					}
				}
				else
				{
					skipColumn(columns[k]->type);				
				}
				
			}
		}
		else
		{
			for(int k = 0; k < columns.size(); ++k)
			{
				skipColumn(columns[k]->type);
			}
		}
	}
	clearerr(file);
	return deletedLines;
}


void Table::skipColumn(int type)
{
	if(type == INT_TYPE)
	{
		fseek(file, sizeof(int), SEEK_CUR);
	}
	else if(type == STRING_TYPE)
	{
		int length = -1;
		fread(& length, sizeof(length),1,file);
		fseek(file, length, SEEK_CUR);
	}
}

#endif
