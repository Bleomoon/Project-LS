#include "bexp.h"

bexp::bexp(const std::string ope, bexp* vleft, bexp* vright) : aexp(ope, vleft, vright) {}

bexp::bexp(const std::string ope, bexp* vleft) : bexp(ope, vleft);

bexp::bexp(const std::string val) : aexp(val) {}

bexp::bexp(const bexp& exp) : aexp(exp){}

bool bexp::isValid(std::string val) {
	//val est non, égal, inférieur ou égal
	if (val == "<=" || val == "==" || val == "non") {
		return true;
	}
	else if (val == "vrai" || val == "faux") { //si vrai ou faux{
		return true;
	}
	else if (val == "et" || val == "ou" || val == "&&" || "||") { //si et, ou{
		return true;
	}
	else {
		std::cout << "Error in creating bexp expression" << std::endl;
		return false;
	}
}