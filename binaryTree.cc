#include <iostream> 
using namespace std;

struct Node 
{ 
	int info; 
	Node *pLeft, *pRight; 
}; 

class Tree 
{ 

public: 

	Tree(); 
	void print() const { pr(root); } 
	//void search(int);
	Node* getRoot() { return root; }

private: 
   
	Node *root; 
	void addNode(int, Node* &); 
	void pr(const Node *) const; 
}; 

Tree::Tree() 
{	
	root = NULL; 
	int x; 
	while (cin >> x, !cin.fail()) 
		addNode(x, root); 
} 

void Tree::addNode(int x, Node* &p) 
{	 
	if (p == NULL) 
	{ 
		p = new Node; 
		p->info = x; 
		p->pLeft = p->pRight = NULL; 
	} 
	else 
		addNode(x, x < p->info ? p->pLeft : p->pRight); 
}

void Tree::pr(const Node *p)const 
{ 
	if (p) 
	{ 
		pr(p->pLeft); 
		cout << p->info << " "; 
		pr(p->pRight); 
	} 
}


void search(Node* p, int x)
{
	if(p->info == x)
	{
		cout << "Found it!" << endl;
		return;
	} 
	else if (p->info > x && p->pLeft)
		search(p->pLeft, x);
	else if (p->pRight)
		search(p->pRight, x);
}


int findPath(Node* p, int x)
{
	if(p->info == x)
	{
		cout << "Found it!" << endl;
		return 0;
	} 
	else if (p->info > x && p->pLeft)
	{
		int res =  findPath(p->pLeft, x);
		if(res>=0)
			return 1 + findPath(p->pLeft, x);
	}
	else if (p->pRight)
	{
		int res =  findPath(p->pRight, x);
		if(res>=0)
			return 1 + findPath(p->pRight, x);
	}
	
	return -1;
	
}

int main() 
{ 
	cout << "Enter some integers to be placed in a binary tree:\n"; 
	Tree t; 
	cout << "Tree contents (in ascending order):\n"; 
	t.print(); 
	cout << endl; 
	
	search(t.getRoot(), 31);
	cout<< findPath(t.getRoot(), 31) << endl;
	
	
	return 0; 
}

 
