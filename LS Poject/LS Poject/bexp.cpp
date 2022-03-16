#include "bexp.h"

bexp::bexp(const std::string ope, bexp* vleft, bexp* vright) {
	if (this->value == "") {
		if (this->isValid(ope)) {
			this->value = ope;
			this->left = vleft;
			this->right = vright;
		}
		else {
			exit(0);
		}
	}
}

bexp::bexp(const std::string ope, bexp* vleft) {
	if (this->value == "") {
		if (this->isValid(ope)) {
			this->value = ope;
			this->left = vleft;
			this->right = nullptr;
		}
		else {
			exit(0);
		}
	}
}

bexp::bexp(const std::string val) {
	if (this->value == "") {
		if (this->isValid(val)) {
			this->value = val;
			this->left = nullptr;
			this->right = nullptr;
		}
		else {
			exit(0);
		}
	}
}

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

std::string bexp::bexp_to_string() {
	std::string s;
	if (this->left == nullptr && this->right == nullptr) {
		s.append(this->value);
	}
	else if (this->left == nullptr) {
		s.append(this->value);
		s.append(" ");
		s.append(this->right->bexp_to_string());
		s.append(")");
	}
	else if (this->right == nullptr) {
		s.append(this->value);
		s.append(" ");
		s.append(this->left->bexp_to_string());
		s.append(")");
	}
	else {
		s.append("(");
		s.append(this->left->bexp_to_string());
		s.append(" ");
		s.append(this->value);
		s.append(" ");
		s.append(this->right->bexp_to_string());
		s.append(")");
	}
	return s;
}