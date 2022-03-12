#ifndef _AEXP_H_
#define _AEXP_H_

#include <string>
#include <vector>
#include <iostream>

//Class axep, has a root and 2 leafs, the leaf can be root or leaf
class aexp
{
	//variables
	std::string value;
	aexp* rLeaf;
	aexp* lLeaf;

public:
	//functions
	aexp(const std::string ope, aexp* vleft, aexp* vright);
	aexp(const std::string val);
	aexp(const aexp& exp);
	~aexp();
	aexp operator+(const aexp& exp);
	void changeLLeaf(aexp* exp);
	void changeRLeaf(aexp* exp);
	void addLLeaf(aexp* exp, const std::string value);
	void addRLeaf(aexp* exp, const std::string value);
	std::string getRoot();
	aexp* getLLeaf();
	aexp* getRLeaf();
	void changeRoot(std::string s);
	std::string aexp_to_string(std::string& rt);
};

#endif