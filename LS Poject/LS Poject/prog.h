#ifndef _PROG_H_
#define _PROG_H_

#include "aexp.h"

class prog : public aexp
{
	//variables
	std::string value;
	prog* left;
	prog* right;
public:
	prog(const std::string ope, prog* vleft, prog* vright);
	prog(const std::string ope, prog* vleft);
	prog(const std::string val);
	prog(const prog& exp);
	bool isValid(std::string val);
	std::string prog_to_string();
};

#endif