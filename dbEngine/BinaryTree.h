#ifndef BINARY_TREE_H
#define BINARY_TREE_H

#include <cstdio>
#include <queue>

using namespace std;

struct Node
{

	bool exists;
	Node* left;
	Node* right;
	int data;
	long address;

	void write(FILE* file);
	void read(FILE* file);
};

void Node::write(FILE* file)
{
	fwrite(&exists, sizeof(exists), 1, file);
	if(exists)
	{
		fwrite(&data, sizeof(data), 1, file);
		fwrite(&address, sizeof(address), 1, file);
	}
	else
	{
		fseek(file, sizeof(data) + sizeof(address), SEEK_CUR);
	}
}

void Node::read(FILE* file)
{
	fread(&exists, sizeof(exists), 1, file);
	if( feof(file) )
    { 
        return;
    }
	if(exists)
	{
		fread(&data, sizeof(data), 1, file);
		fread(&address, sizeof(address), 1, file);
	}
	else
	{
		fseek(file, sizeof(data) + sizeof(address), SEEK_CUR);
	}
}


class BinaryTree
{

	Node* root;
	int existingNodes;

public:

	BinaryTree();
	~BinaryTree();
	void print() const;

	void addValue(int data, long address);

	void write(FILE* file);
	void search(FILE* file, int value);


private:
	void deleteRecursive(Node* node);
	void printRecursive(Node*, int) const;
	void addRecursive(Node* node, int data, long address);

};


BinaryTree::BinaryTree()
{
	root = NULL;
	existingNodes = 0;
}

BinaryTree::~BinaryTree()
{
	if(root)
	{
		deleteRecursive(root);
		delete root;
	}
}


void BinaryTree::write(FILE* file)
{
	queue<Node*> q;
	q.push(root);

	int nodesToWrite = existingNodes;
	int i = 0;
	while(!q.empty() && nodesToWrite > 0)
	{
		i++;
		if(i == 10)
			break;
		Node* curr = q.front();
		if(curr->exists)
		{
			--nodesToWrite;
		}

		q.pop();

		curr->write(file);
		if(!curr->left)
		{
			curr->left = new Node();
			curr->left->exists = 0;
		}
		q.push(curr->left);
		
		if(!curr->right)
		{
			curr->right = new Node();
			curr->right->exists = 0;
		}
		q.push(curr->right);
	} 
}

// TODO make it work 
void BinaryTree::search(FILE* file, int value)
{
	fseek(file, 0, SEEK_SET);
	Node curr;
	int pos = 0;
	while(true)
	{

		curr.read(file);
		if( feof(file) )
	    { 
	        break;
	    }
		if(curr.exists)
		{
			cout << "READED: " << curr.data << ": " << curr.address << endl;

			if(curr.data == value)
			{
				cout << curr.data << ": " << curr.address << endl;
			}
			else if (curr.data > value)
			{
				fseek(file, (2 * pos) + 1, SEEK_SET);
			}
			else
			{
				fseek(file, (2 * pos) + 2, SEEK_SET);
			}
		}
		else
		{
			break;
		}

		pos++;
	}
}


void BinaryTree::addValue(int data, long address)
{
	if(!root)
	{
		root = new Node();
		root->data = data;
		root->address = address;
		++existingNodes;
 			root->exists = true;
		return;
	}

	addRecursive(root, data, address);
}


void BinaryTree::addRecursive(Node* node, int data, long address)
{
	if(data <= node->data)
	{
		if(node->left)
		{
			addRecursive(node->left, data, address);
		}
		else
		{
			Node* newNode = new Node();
			newNode->data = data;
			newNode->address = address;
			newNode->exists = true;

			node->left = newNode;
			existingNodes++;
		}
	}
	else
	{
		if(node->right)
		{
			addRecursive(node->right, data, address);
		}
		else
		{
			Node* newNode = new Node();
			newNode->data = data;
			newNode->address = address;
			newNode->exists = true;

			node->right = newNode;
			existingNodes++;
		}	
	}


}

void BinaryTree::print() const
{
	cout << root->data << endl;
	if(root->left)
		printRecursive(root->left, 1);
	if(root->right)
		printRecursive(root->right, 1);
}

void BinaryTree::printRecursive(Node* node, int cnt) const
{
	for (int i = 0; i < cnt; ++i)
	{
		cout << "\t";
	}
	cout <<  node->data  << endl;
	if(node->left)
		printRecursive(node->left, cnt + 1);
	if(node->right)
			printRecursive(node->right, cnt + 1);
}



void BinaryTree::deleteRecursive(Node* node)
{
	if(node->left)
	{
		deleteRecursive(node->left);
		delete node->left;
	}
	if(node->right)
	{
		deleteRecursive(node->right);
		delete node->right;
	}
}


#endif