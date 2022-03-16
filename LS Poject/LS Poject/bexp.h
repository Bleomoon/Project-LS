#ifndef _BEXP_H_
#define _BEXP_H_

#include "aexp.h"

class bexp : public aexp
{
	//variables
	std::string value;
	bexp* left;
	bexp* right;
public:
	bexp(const std::string ope, bexp* vleft, bexp* vright);
	bexp(const std::string ope, bexp* vleft);
	bexp(const std::string val);
	bexp(const bexp& exp);
	bool isValid(std::string val);
	std::string bexp_to_string();
};

#endif