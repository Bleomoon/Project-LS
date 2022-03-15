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
	aexp* left;
	aexp* right;

public:
	//functions
	aexp(const std::string ope, aexp* vleft, aexp* vright);
	aexp(const std::string ope, aexp* vleft);
	aexp(const std::string val);
	aexp(const aexp& exp);
	~aexp();
	aexp operator=(const aexp& exp);
	void changeLeft(aexp* exp);
	void changeRight(aexp* exp);
	void addLeft(aexp* exp, const std::string value);
	void addRight(aexp* exp, const std::string value);
	bool isValid(std::string val);
	std::string getRoot();
	aexp* getLeft();
	aexp* getRight();
	void changeRoot(std::string s);
	std::string aexp_to_string(std::string& rt);
};

#endif