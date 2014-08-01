#include <iostream> 
using namespace std;

struct Node 
{ 
	int info; 
	Node** childrens;
	int childrensCount;
}; 

class Tree 
{ 

public: 

	Tree(); 
	Node* getRoot() { return root; }

private: 
   
	Node *root; 

}; 

Tree::Tree() 
{	
	root = new Node;
	root->info = 1;
	root->childrensCount=3;
	root->childrens = new Node* [root->childrensCount];
	root->childrens[0] = new Node;
	root->childrens[0]->info = 2;
	root->childrens[1] = new Node;
	root->childrens[1]->info = 3;
	root->childrens[2] = new Node;
	root->childrens[2]->info = 4;
	
	root->childrens[0]->childrensCount = 2;
	root->childrens[0]->childrens = new Node* [root->childrens[0]->childrensCount];
	root->childrens[0]->childrens[0] = new Node;
	root->childrens[0]->childrens[0]-> info = 5;
	root->childrens[0]->childrens[1] = new Node;
	root->childrens[0]->childrens[1]-> info = 6;
	
	root->childrens[2]->childrensCount = 3;
	root->childrens[2]->childrens = new Node* [root->childrens[0]->childrensCount];
	root->childrens[2]->childrens[0] = new Node;
	root->childrens[2]->childrens[0]-> info = 7;
	root->childrens[2]->childrens[1] = new Node;
	root->childrens[2]->childrens[1]-> info = 8;
	root->childrens[2]->childrens[2] = new Node;
	root->childrens[2]->childrens[2]-> info = 9;
	
	root->childrens[2]->childrens[1]->childrensCount = 1;
	root->childrens[2]->childrens[1]->childrens = new Node*[root->childrens[2]->childrens[1]->childrensCount];
	root->childrens[2]->childrens[1]->childrens[0] = new Node;
	root->childrens[2]->childrens[1]->childrens[0]-> info = 9;

	
} 

int findPath(Node* p, int x)
{
	if(p->info == x)
	{
		cout << "Found it!" << endl;
		return 0;
	}
	else 
	{
	  for(int i=0; i< p->childrensCount; i++)
	  {
	    int path = findPath(p->childrens[i], x);
	    if (path >= 0)
	      return 1 + path;
	  }
	}
	
	return -1;
}

int main() 
{ 
	
	Tree t; 
	cout<< findPath(t.getRoot(), 9) << endl;	
	
	return 0; 
}

 
