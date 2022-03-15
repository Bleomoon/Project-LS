#include "aexp.h"

//put leaf to null and char to value
aexp::aexp(const std::string ope, aexp* vleft, aexp* vright) {
	this->value = ope;
	this->left = vleft;
	this->right = vright;
}

aexp::aexp(const std::string val) {
	this->value = val;
	this->left = nullptr;
	this->right = nullptr;
}

//by copy
aexp::aexp(const aexp& exp) {
	this->value = exp.value;
	this->left = exp.left;
	this->right = exp.right;
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

std::string aexp::aexp_to_string(std::string& rt) {
	if (this->left == nullptr && this->right == nullptr) {
		rt.append(this->value);
	}
	else if (this->left == nullptr) {
		rt.append(this->value);
		rt.push_back(' ');
		this->right->aexp_to_string(rt);
		rt.push_back(')');
	}
	else if (this->left == nullptr) {
		rt.append(this->value);
		rt.push_back(' ');
		this->left->aexp_to_string(rt);
		rt.push_back(')');
	}
	else {
		rt.push_back('(');
		this->left->aexp_to_string(rt);
		rt.push_back(' ');
		rt.append(this->value);
		rt.push_back(' ');
		this->right->aexp_to_string(rt);
		rt.push_back(')');
	}
	return rt;
}