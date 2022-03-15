#ifndef _BEXP_H_
#define _BEXP_H_

#include "aexp.h"

class bexp : public aexp
{
public:
	bexp(const std::string ope, bexp* vleft, bexp* vright);
	bexp(const std::string ope, bexp* vleft);
	bexp(const std::string val);
	bexp(const bexp& exp);
	bool isValid(std::string val);
};

#endif