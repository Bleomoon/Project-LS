#include "prog.h"

prog::prog(const std::string ope, prog* vleft, prog* vright) {
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

prog::prog(const std::string ope, prog* vleft) {
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

prog::prog(const std::string val) {
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

prog::prog(const prog& exp) : aexp(exp) {}

bool prog::isValid(std::string val) {
	//val skip
	if (val == "<=" || val == "==" || val == "non") {
		return true;
	}
	else if (val == "vrai" || val == "faux") { //si variables ou 
		return true;
	}
	else if (val == "et" || val == "ou" || val == "&&" || "||") { //si et, ou{
		return true;
	}
	else {
		std::cout << "Error in creating prog expression" << std::endl;
		return false;
	}
}

std::string prog::prog_to_string() {
	std::string s;
	if (this->left == nullptr && this->right == nullptr) {
		s.append(this->value);
	}
	else if (this->left == nullptr) {
		s.append(this->value);
		s.append(" ");
		s.append(this->right->prog_to_string());
		s.append(")");
	}
	else if (this->right == nullptr) {
		s.append(this->value);
		s.append(" ");
		s.append(this->left->prog_to_string());
		s.append(")");
	}
	else {
		s.append("(");
		s.append(this->left->prog_to_string());
		s.append(" ");
		s.append(this->value);
		s.append(" ");
		s.append(this->right->prog_to_string());
		s.append(")");
	}
	return s;
}