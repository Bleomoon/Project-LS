#include "aexp.h"

//put leaf to null and char to value
aexp::aexp(const std::string ope, aexp* vleft, aexp* vright) {
	this->value = ope;
	this->lLeaf = vleft;
	this->rLeaf = vright;
}

aexp::aexp(const std::string val) {
	this->value = val;
	this->lLeaf = nullptr;
	this->rLeaf = nullptr;
}

//by copy
aexp::aexp(const aexp& exp) {
	this->value = exp.value;
	this->lLeaf = exp.lLeaf;
	this->rLeaf = exp.rLeaf;
}

aexp::~aexp()
{
	if (this->rLeaf != nullptr) {
		delete this->rLeaf;
	}
	
	if (this->lLeaf != nullptr) {
		delete this->lLeaf;
	} 
}

aexp aexp::operator+(const aexp& exp) {
	std::cout << " an operator for axep + axep has not been decided yet, returned current expression" << std::endl;
	return *this;
}

//Add values to current exp like 3 + 5 * 7 and we add * 8 we get (3 + 5 * 7) * 8 where * 8 is on first root
void aexp::addLLeaf(aexp* exp, const std::string value) {
	aexp* cpy = new aexp(*this);
	this->value = value;
	this->lLeaf = exp;
	this->rLeaf = cpy;
}

void aexp::addRLeaf(aexp* exp, const std::string value) {
	aexp* cpy = new aexp(*this);
	this->value = value;
	this->rLeaf = exp;
	this->lLeaf = cpy;
}

void aexp::changeRoot(std::string s) {
	this->value = s;
}

std::string aexp::getRoot() {
	return this->value;
}

void aexp::changeLLeaf(aexp* exp) {
	this->lLeaf = exp;
}

void aexp::changeRLeaf(aexp* exp) {
	this->rLeaf = exp;
}

aexp* aexp::getLLeaf() {
	return this->lLeaf;
}

aexp* aexp::getRLeaf() {
	return this->rLeaf;
}

std::string aexp::aexp_to_string(std::string& rt) {
	if (this->lLeaf == nullptr && this->rLeaf == nullptr) {
		rt.append(this->value);
	}
	else if (this->lLeaf == nullptr) {
		rt.append(this->value);
		rt.push_back(' ');
		this->rLeaf->aexp_to_string(rt);
		rt.push_back(')');
	}
	else if (this->lLeaf == nullptr) {
		rt.append(this->value);
		rt.push_back(' ');
		this->lLeaf->aexp_to_string(rt);
		rt.push_back(')');
	}
	else {
		rt.push_back('(');
		this->lLeaf->aexp_to_string(rt);
		rt.push_back(' ');
		rt.append(this->value);
		rt.push_back(' ');
		this->rLeaf->aexp_to_string(rt);
		rt.push_back(')');
	}
	return rt;
}