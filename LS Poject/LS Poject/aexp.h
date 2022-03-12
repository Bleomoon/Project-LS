#ifndef _AEXP_H_
#define _AEXP_H_

#include <string>
#include <vector>
#include <iostream>

//Class axep, has a root and 2 leafs, the leaf can be root or leaf
class aexp
{
	//variables
	char ope;
	aexp* rLeaf;
	aexp* lLeaf;

public:
	//functions
	aexp(const char val, const char val1, const char val2);
	aexp(const char val);
	~aexp();
	aexp operator+(const aexp& exp);
	void addLLeaf(const char ope, const char val);
	void addRLeaf(const char ope, const char val);
	char getRoot();
	char getLLeaf();
	char getRLeaf();
	friend std::ostream& operator<<(std::ostream& os, const aexp& exp);//TODO
};

#endif