#include "aexp.h"

//put leaf to null and char to value
aexp::aexp(const std::string ope, aexp* vleft, aexp* vright) {
	if (this->isValid(ope)) {
		this->value = ope;
		this->left = vleft;
		this->right = vright;
	}
	else {
		exit(0);
	}
}

aexp::aexp(const std::string ope, aexp* vleft) {
	if (this->isValid(ope)) {
		this->value = ope;
		this->left = vleft;
		this->right = nullptr;
	}
	else {
		exit(0);
	}
}

aexp::aexp(const std::string val) {
	if (this->isValid(val)) {
		this->value = val;
		this->left = nullptr;
		this->right = nullptr;
	}
	else {
		exit(0);
	}
}

//by copy
aexp::aexp(const aexp& exp) {
	this->value = exp.value;
	this->left = exp.left;
	this->right = exp.right;
}

aexp::aexp() {
	this->left = nullptr;
	this->right = nullptr;
}

aexp::~aexp()
{
	if (this->right != nullptr) {
		delete this->right;
	}
	
	if (this->left != nullptr) {
		delete this->left;
	} 
}

aexp aexp::operator=(const aexp& exp) {
	if (&exp != this) {
		this->value = exp.value;
		delete this->left;
		delete this->right;
		this->left = exp.left;
		this->right = exp.right;
	}
	return *this;
}

//Add values to current exp like 3 + 5 * 7 and we add * 8 we get (3 + 5 * 7) * 8 where * 8 is on first root
void aexp::addLeft(aexp* exp, const std::string value) {
	aexp* cpy = new aexp(*this);
	this->value = value;
	this->left = exp;
	this->right = cpy;
}

void aexp::addRight(aexp* exp, const std::string value) {
	aexp* cpy = new aexp(*this);
	this->value = value;
	this->right = exp;
	this->left = cpy;
}

void aexp::changeRoot(std::string s) {
	this->value = s;
}

std::string aexp::getRoot() {
	return this->value;
}

void aexp::changeLeft(aexp* exp) {
	this->left = exp;
}

void aexp::changeRight(aexp* exp) {
	this->right = exp;
}

aexp* aexp::getLeft() {
	return this->left;
}

aexp* aexp::getRight() {
	return this->right;
}

bool aexp::isValid(std::string val) {
	//si taille de val > 1 alors on a un nombre
	if (val.size() > 1) {
		//si constantes
		for (int i = 0; i < val.size(); i++) {
			if (std::isdigit(val.at(i)) == false) {
				std::cout << "Error in creating aexp expression, number is unknown" << std::endl;
				return false;
			}
		}
		return true;
	}
	else if ((val.at(0) >= 'a' && val.at(0) <= 'z') || (val.at(0) >= 'A' && val.at(0) <= 'Z')) { //si variables{
		return true;
	}
	else if (val == "+" || val == "-" || val == "*") { //si +, - ou *{
		return true;
	}
	else if (std::isdigit(val.at(0))) {
		return true;
	}
	else {
		std::cout << "Error in creating aexp expression, variables or operator are unkown" << std::endl;
		return false;
	}
}

std::string aexp::aexp_to_string() {
	std::string s;
	if (this->left == nullptr && this->right == nullptr) {
		s.append(this->value);
	}
	else if (this->left == nullptr) {
		s.append(this->value);
		s.append(" ");
		s.append(this->right->aexp_to_string());
		s.append(")");
	}
	else if (this->right == nullptr) {
		s.append(this->value);
		s.append(" ");
		s.append(this->left->aexp_to_string());
		s.append(")");
	}
	else {
		s.append("(");
		s.append(this->left->aexp_to_string());
		s.append(" ");
		s.append(this->value);
		s.append(" ");
		s.append(this->right->aexp_to_string());
		s.append(")");
	}
	return s;
}